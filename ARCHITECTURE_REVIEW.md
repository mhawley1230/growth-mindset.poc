# Architecture Review & Refactoring Plan

GrowthMindsetPOC — Godot 4 farming game. Review of the context/controller pattern in `/features` and a sequenced plan to bring the rest of the project in line.

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

### Phase 0 — Cleanup & ground rules (low risk, do first)

1. Delete the `scenes/levels/*.tmp` files from disk (already git-ignored).
2. Delete or migrate `scenes/managers/entity_spawn_manager.gd` — its role now belongs to `EntitySpawnController`. Remove the dead `Refs`/`NodeExtensions` references.
3. Replace `project_structure_notes.txt` with a short `ARCHITECTURE.md` that states the role definitions below. Keep `NOTES.txt` as a design-questions scratchpad.
4. **Fix the taxonomy and apply it consistently:**
   - *Context* — owns lifecycle + a child scene (`build/bind/initialize`).
   - *Controller* — injected stateful logic service (`extends Node`).
   - *Component* — stateless behavior attached to an entity. Drop the `/handlers` folder name or the `Handler` suffix — pick one. Recommend: folder `components/`, suffix `Component`, retire `Handler`.
   - *Entity* — an in-world `CharacterBody2D`/`Area2D` (Player, Plant, Customer). Rename `PlantController` → `PlantEntity` (or just `Plant` scene script, with the resource renamed `PlantData`).

### Phase 1 — Repair the DI chain (critical path)

This is the single most important fix; nothing downstream works without it.

5. In `GameContext.handle_level_select()`, after instantiating the level, call the full lifecycle: `current_level.build_services()` → `current_level.bind_services(_game_state_holder, _game_controller)` → `current_level.initialize()` — mirroring how `RootContext` drives `GameContext`.
6. Remove the premature `bind_services(...)` call from `LevelContext._ready()` (it runs before injection). Let the parent context drive binding instead.
7. Decide where `GameController` is built and owned — recommend `GameContext.build_services()` creates it (it's game-scoped, not level-scoped) and passes it down to the level during `bind_services`. Wire `on_game_loss` up to `GameContext`.
8. Have `GameContext.build_services()` also create `InventoryController`, bind it with the state holder, and pass it to `GameOverlay.initialize(...)` so the overlay/UI get a live controller.

### Phase 2 — Restore core gameplay through the pattern

9. `EntitySpawnController`: fix `instantiate_player()` (`.instantiate()` + position at `_player_spawn_point`), call its `bind_services` from `LevelContext`, and have the level ask it to spawn the player instead of placing the player statically in `base_level.tscn`.
10. Uncomment and finish `Player._input` / `_physics_process`, routing through the components. Confirm movement, planting, harvesting, trading paths each call into a component method, not inline logic.
11. Reimplement `InventoryController`'s add/remove/get on top of `GameState` (move the commented dictionary logic in, but key it off `GameState` rather than a private field, so resets work via the holder). Reconnect `SeedsBox`/`PlantsBox.bind_events()` to `on_inventory_updated`.
12. Flesh out `PlantingComponent` and `HarvestingComponent` to call `InventoryController` (injected, not via `Global`).

### Phase 3 — Migrate the customer / trading system

13. Replace all former `SignalBus` calls in `Path`, `TradeArea`, `CustomerQueue`, `CustomerOrderComponent` with local signals wired by the `LevelContext` (or a dedicated `CustomerSpawnController` built by the level).
14. Resolve the open question in `NOTES.txt` (where customer behavior lives) by making spawning a level-owned controller and per-customer behavior a set of components on the customer entity — consistent with the Player composition model.
15. Finish `ActionHandlerComponent.trade` / `TradingComponent` against the injected `InventoryController`.

### Phase 4 — Fill out the flow

16. Add the missing **menu / end-screen** feature under `features/menu/` with a `MenuContext`, and wire `RootContext.handle_loss → go_to_menu` plus `request_start_game`.
17. Implement `PlantEntity`'s growth-state machine (the `TODO: StateManager` in `plant_controller.gd`) as a small state component rather than the current `_process` polling of a progress bar.

### Phase 5 — Verification

18. Run the project in Godot and confirm: no script errors on load, level loads via the full context chain, player spawns and moves, planting/harvesting update inventory and UI, pause toggles state, loss returns to menu.
19. Add a lightweight check that no active (uncommented) code references `Global`, `SignalBus`, `Refs`, `NodeExtensions`, or `Utils` (grep gate), and that every Context implements all three lifecycle methods.

---

## 4. Summary

The pattern itself is sound and already proven on the `Root → Game` handoff. The project's real problem is not the design but that the migration stalled halfway: the dependency-injection chain breaks at `LevelContext`, `GameController` and `InventoryController` are written but never wired, the player is inert, and a layer of pre-refactor singleton-based code still sits alongside the new structure. Fixing the DI chain (Phase 1) is the unlock — once dependencies flow all the way down to the level and its entities, the remaining work is mostly filling in component bodies that already have the right shape.
