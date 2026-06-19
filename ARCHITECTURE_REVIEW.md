# Architecture Review & Refactoring Plan

GrowthMindsetPOC — Godot 4 farming game. Review of the context/controller pattern in `/features` and a sequenced plan to bring the rest of the project in line.

> **Status (updated):** Phases 0, 1, and 2 are complete. Phase 3 is done on the
> code side; its runnable customer loop is blocked on scene/content work that
> can't be done headless (no customer entity scene exists). Phases 4–5 remain.
> All work was verified statically (no Godot CLI in the build environment), so a
> confirming open in the editor is still pending — see Phase 5. Sections 1 and 2
> below describe the *original* state at review time; the per-phase notes in
> section 3 record what has since changed.

---

## 1. The pattern, as written

The project is mid-migration (commit `ce2a4a9 feat: refactor to context/controller script structure`) from a global-singleton design to an explicit **Context / Controller / Component** architecture with manual dependency injection. No autoloads are registered; the old `Global` / `SignalBus` / `Refs` / `NodeExtensions` / `Utils` singletons are gone, and most code that depended on them is commented out awaiting reimplementation.

The pattern has four roles and one lifecycle contract.

**Contexts** are scene-tree composition roots that own a lifecycle stage and a child scene. They form a chain — `RootContext → GameContext → LevelContext` — each one instantiating the next scene and pushing dependencies down into it. Contexts implement a three-phase lifecycle:

- `build_services()` — instantiate the services/controllers this context owns
- `bind_services(...)` — receive dependencies from the parent (constructor injection by hand)
- `initialize()` — connect signals and start behavior

**Controllers** are stateful logic services (`extends Node`) that operate on game state and are injected where needed. They expose `bind_services(...)` plus domain methods. Examples: `GameController`, `InventoryController`, `EntitySpawnController`.

**Holder** (`GameStateHolder`) wraps a swappable `GameState` object so that references handed out during binding stay valid across resets — the holder is stable, the state inside it is replaceable.

**Components / Handlers** are stateless behavior units (`extends Node`) attached to an entity and called by it. The `Player` entity composes `InputHandlerComponent`, `MovementHandlerComponent`, `ActionHandlerComponent`, etc., and orchestrates them in `_input` / `_physics_process`.

**Overlay** (`GameOverlay`) is the UI layer, with its own `initialize(controller)` that injects a controller into UI sub-views (`SeedsBox`, `PlantsBox`), which themselves follow `initialize → bind_services → bind_events`.

Communication direction: dependencies flow **down** via `bind_services`; events flow **up** via `signal`. No global bus.

---

## 2. Conformance audit

### Conforms (implemented and consistent)

`RootContext`, `GameContext`, `GameStateHolder`, `GameState`, `GameOverlay`, `SeedsBox`, `PlantsBox` all follow the lifecycle contract cleanly. The Root → Game context handoff (`build_services` → `bind_services` → `initialize`) is wired and works.

### Broken or incomplete (conforms in shape, not in function)

- **`LevelContext` — broken DI chain.** `_ready()` calls `bind_services(_game_state_holder, _game_controller)`, but both vars are still `null` at that point — nothing injects them first. Meanwhile `GameContext.handle_level_select()` instantiates the level and calls only `current_level.initialize()`; it never calls the level's `build_services`/`bind_services`. So the level never actually receives the state holder or game controller. This is the highest-leverage break.
- **`GameController` — fully written but never instantiated.** No context builds or binds it. Its pause/active/loss state machine in `_process` is dead code. Nothing owns it.
- **`EntitySpawnController` — never bound + real bug.** `instantiate_player()` calls `player_packed_scene.instantiate_player_spawn_point()`, which is not a method (should be `.instantiate()` then position at `_player_spawn_point`). `bind_services` is never called. In practice the player is placed statically in `base_level.tscn` instead.
- **`InventoryController` — shell only.** `bind_services`/`setup` exist; all real inventory operations are commented out. Not instantiated by any context. `on_inventory_updated` is never connected because `SeedsBox`/`PlantsBox.bind_events()` are commented out, so the UI never updates.
- **`Player` — inert.** References its components via `@onready`, but the entire `_input` and `_physics_process` bodies are commented out, so the player neither moves nor acts.
- **Components are stubs.** `PlantingComponent`, `HarvestingComponent` are fully commented; `ActionHandlerComponent.trade`, `TradingComponent.trade` are placeholders; `MovementHandlerComponent.handle_deceleration` just zeroes velocity (no real deceleration).

### Naming / taxonomy drift

- **"Controller" vs "Handler" vs "Component" is inconsistent.** `MovementHandlerComponent` and `ActionHandlerComponent` carry both suffixes and live in `/handlers`; `CustomerSpawnerHandler` is a "Handler" but is empty; `PlantController` is an `Area2D` entity, not a DI controller. The words need fixed definitions.
- **`Plant` is defined twice in spirit.** `plant.gd` (a `Resource` data definition) and `plant_controller.gd` (`class_name PlantController extends Area2D`, an in-world entity). The "Controller" naming here clashes with the controller role elsewhere.

### Legacy leftovers (should be removed or migrated)

- **`scenes/managers/entity_spawn_manager.gd`** is still active code referencing the deleted `Refs` and `NodeExtensions` globals — it would error if loaded. It duplicates `EntitySpawnController`'s purpose under the old "Manager" name.
- **`scenes/levels/*.tmp`** — ~90 Godot autosave temp files checked into the tree. `.gitignore` now ignores `.tmp`, but the existing ones are still on disk.
- **`project_structure_notes.txt`** describes an old `/game_flow`, `/game_state`, `/menu` layout that no longer matches `/features`. **`NOTES.txt`** captures open design questions (where customer behavior should live) that are still unresolved.
- **Customer system** (`Path`, `CustomerOrderComponent`, `CustomerSpawnerHandler`, `customer_queue`, `trade_area`) communicates through the removed `SignalBus` and is mostly commented; it predates the new pattern.
- **No menu feature** exists in `/features`, though `RootContext` comments and the notes reference a menu / end screen / `handle_loss → go_to_menu` flow.

---

## 3. Refactoring plan

Ordered so each phase leaves the game runnable and unblocks the next. Phases 1–2 are the critical path; everything else depends on a working DI chain.

### Phase 0 — Cleanup & ground rules ✅ DONE

1. ✅ Deleted all `.tmp` autosave files (97 in `scenes/levels`, 1 in `scenes/entities/paths`, 2 strays in `assets/`); pruned the emptied folders.
2. ✅ Deleted `scenes/managers/entity_spawn_manager.gd` (+`.uid`) — confirmed nothing referenced it.
3. ✅ Created `ARCHITECTURE.md` with the role definitions and lifecycle contract. (`project_structure_notes.txt` was already removed in the working tree; `NOTES.txt` kept.)
4. ✅ **Taxonomy fixed and applied consistently** — `Handler` retired everywhere: folder `features/handlers/` → `features/components/`; `*HandlerComponent` → `*Component`; `CustomerSpawnerHandler` → `CustomerSpawnerComponent`; `PlantController` (entity) → `PlantEntity`; `Plant` (resource) → `PlantData`. Every `class_name`, code reference, scene node name, `%`-unique ref, exported NodePath, `.tres` `script_class`, and `path=` string updated; all `.uid` values preserved so uid-based scene refs never broke.

   Original taxonomy targets, for reference:
   - *Context* — owns lifecycle + a child scene (`build/bind/initialize`).
   - *Controller* — injected stateful logic service (`extends Node`).
   - *Component* — stateless behavior attached to an entity. Drop the `/handlers` folder name or the `Handler` suffix — pick one. Recommend: folder `components/`, suffix `Component`, retire `Handler`.
   - *Entity* — an in-world `CharacterBody2D`/`Area2D` (Player, Plant, Customer). Rename `PlantController` → `PlantEntity` (or just `Plant` scene script, with the resource renamed `PlantData`).

### Phase 1 — Repair the DI chain ✅ DONE

This was the single most important fix; nothing downstream worked without it.

5. ✅ `GameContext.handle_level_select()` now runs the full lifecycle on the level: `build_services()` → `bind_services(_game_state_holder, _game_controller, _inventory_controller)` → `initialize()`. (Inventory is passed down too, since the level needs it for spawning and seeding.)
6. ✅ Removed the premature `bind_services(...)` from `LevelContext._ready()`; the parent context drives binding. The spawn controller is fetched via `@onready` instead.
7. ✅ `GameContext.build_services()` creates and owns `GameController`; `on_game_loss` is re-emitted up to `GameContext` and on to `RootContext.handle_loss` (placeholder until Phase 4's menu). `GameController`'s binding completes in `LevelContext.initialize()`, where the level-scoped `EntitySpawnController` is available.
8. ✅ `GameContext.build_services()` also creates `InventoryController`, binds it with the holder, and calls `overlay.initialize(...)` (guarded — the overlay scene is not yet attached, see Phase 2 note).

   Supporting fixes that made the chain runnable: `GameStateHolder.setup()` now creates the `GameState`; `GameController.state` is null-safe; `InventoryController.reset()` added; `EntitySpawnController.instantiate_player()`'s parse-error method call fixed.

### Phase 2 — Restore core gameplay through the pattern ✅ DONE

9. ✅ `EntitySpawnController.bind_services()` now takes the inventory controller too and is called from `LevelContext`, which then calls `instantiate_player()`. (There was no static player to remove — `base_level.tscn` only had an unused `player.tscn` ext_resource; the spawn controller already had its `player_packed_scene` and `_player_spawn_point` assigned.) The spawned `Player` gets the `InventoryController` injected via `Player.bind_services(...)`.
10. ✅ `Player._physics_process` / `_input` restored and route through components: `MovementComponent` (movement + `move_and_slide`), `CursorPositionComponent` (half-tile snap via `GameConstants.TILE_SIZE`), `PlantingComponent` (action 1), `HarvestingComponent` (action 2). Action 3 (trading) is a Phase 3 placeholder.
11. ✅ Inventory now lives on `GameState.inventory` (owned by the holder, cleared by `reset()`); `InventoryController` has `add`/`remove`/`get_count`/`get_category`/`reset`. `SeedsBox`/`PlantsBox.bind_events()` reconnected to `on_inventory_updated`.
12. ✅ `PlantingComponent.create_plant()` and `HarvestingComponent.harvest_plant()` implemented against the injected `InventoryController` (seed check + spend on plant; ready-check + credit on harvest). `LevelContext` seeds a placeholder starting inventory.

   **Two remaining scene/editor tasks (code is ready, flagged in comments):**
   - Populate `ActionComponent.available_plants` in `player.tscn` (assign `tomato.tscn`/`potato.tscn`) — planting no-ops safely until then.
   - Attach the `GameOverlay` scene to `GameContext` in `game_scene.tscn` and finish the box layouts — the UI binding is correct but there is no overlay node in the scene yet, so inventory counts don't render.

### Phase 3 — Migrate the customer / trading system ✅ CODE DONE · ⚠️ scenes pending

Discovery during this phase: the customer/trading scripts were **orphaned** — no scene referenced `Path`/`TradeArea`/`CustomerQueue`/`CustomerSpawnerComponent`, there is **no customer entity scene at all**, and the `SignalBus` calls the plan meant to migrate were already commented out. So the work was less "migrate off SignalBus" and more "lay down the conformant code skeleton"; the actual runnable loop needs scenes built in the editor.

13. ✅ `TradeArea` and `CustomerQueue` now declare and emit **local signals** (`player_entered`, `customer_entered`, `trade_area_exited`; `customer_arrived`) instead of `SignalBus`. `TradeArea` self-wires to its built-in `body_entered`/`body_exited`. `Path` is guarded (null customer/movement) and emits `customer_finished` instead of blindly freeing.
14. ✅ Design decision recorded in `NOTES.txt`: the customer is a `CharacterBody2D` entity composed of components (movement + `CustomerOrderComponent`); a `Path` carries it; **spawning is a level-owned authority** (`CustomerSpawnerComponent`, fleshed out with a guarded `spawn()`/`setup()` and a `customer_spawned` signal, analogous to `EntitySpawnController`). `CustomerOrderComponent.create_order()` now builds a real randomized, size-capped order keyed by product name.
15. ✅ Trading implemented against the injected `InventoryController`: `TradingComponent.execute(order, inventory)` validates the whole order then swaps plants for seed payment; `ActionComponent.try_trade(...)` gates on trade-area state and delegates; `Player` action 3 calls it (safe no-op until the customer system feeds it an order).

   **Remaining (editor/content, can't be done headless):** build the customer entity scene (`CharacterBody2D` + sprite + components, group `"customer"`), a `Path` scene, and place `CustomerSpawnerComponent` / `TradeArea` / `CustomerQueue` nodes in the level, then assign exports and connect the local signals to the player's `ActionComponent` setters.

### Phase 4 — Fill out the flow

16. Add the missing **menu / end-screen** feature under `features/menu/` with a `MenuContext`, and wire `RootContext.handle_loss → go_to_menu` plus `request_start_game`.
17. Implement `PlantEntity`'s growth-state machine (the `TODO: StateManager` in `plant_controller.gd`) as a small state component rather than the current `_process` polling of a progress bar.

### Phase 5 — Verification

18. Run the project in Godot and confirm: no script errors on load, level loads via the full context chain, player spawns and moves, planting/harvesting update inventory and UI, pause toggles state, loss returns to menu.
19. Add a lightweight check that no active (uncommented) code references `Global`, `SignalBus`, `Refs`, `NodeExtensions`, or `Utils` (grep gate), and that every Context implements all three lifecycle methods.

---

## 4. Summary

The pattern itself is sound and already proven on the `Root → Game` handoff. The project's real problem was not the design but that the migration had stalled halfway. Phases 0–2 have now addressed the core of that: the legacy singleton-era code is gone and the taxonomy is consistent (Phase 0); the dependency-injection chain flows end to end from `RootContext` down through `GameContext`, `LevelContext`, the `EntitySpawnController`, and into the spawned `Player` (Phase 1); and core gameplay — movement, cursor, planting, harvesting, and a holder-owned inventory model — runs through components and controllers rather than globals (Phase 2).

What remains: Phase 3 migrates the customer/trading system off the removed `SignalBus`; Phase 4 adds the menu/end-screen flow and the plant growth-state machine; Phase 5 is verification. Two Phase-2 scene/editor tasks are also outstanding (assigning `ActionComponent.available_plants` and attaching the `GameOverlay` scene). And because there is no Godot CLI in the build environment, all Phase 0–2 work was verified by static analysis (arity, types, references, uid/path integrity) — a confirming open in the editor remains the first item of Phase 5.
