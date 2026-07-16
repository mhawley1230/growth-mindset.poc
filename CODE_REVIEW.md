# Code Review — 2026-07-15

Scope: full `/features` tree against the roles/contract in `ARCHITECTURE.md` and
the audit in `ARCHITECTURE_REVIEW.md`. `ARCHITECTURE_REVIEW.md` was written
mid-Phase-3, before the customer entity scene existed; this review reflects
the current state (frog entity scene built, trading logic wired end to end)
and should be read as an update to it, not a replacement.

---

## 1. Conformance — what's improved since the last audit

- **Phase 2's two flagged scene tasks are done.** `base_level.tscn` now
  assigns `available_plants` (tomato/potato) and `_level_overlay_packed`
  (`level_overlay.tscn`) on `BaseLevel`, and `LevelOverlay`/`HUDLayer`/
  `SeedsBox`/`PlantsBox` are fully wired. `ARCHITECTURE_REVIEW.md` §3 Phase 2
  still lists these as outstanding — that note is stale.
- **Phase 3's "remaining editor work" is substantially done.** `frog_entity.tscn`
  exists (`CharacterBody2D` + `Sprite2D` + `CollisionShape2D` +
  `CustomerOrderComponent`, group `"customer"`, script `CustomerEntity`).
  `TradeArea`/`PathController` are placed under `CustomerArea` in
  `base_level.tscn` and wired to the player's `ActionComponent` via
  `LevelContext._wire_trade_area()`. Trading now runs through
  `CustomerEntity.get_order()` → `TradingComponent.execute()` →
  `trade_completed`, with console logging on both outcomes.
- **Contract adherence is otherwise strong.** `RootContext → GameContext →
  LevelContext` drives `build_services → bind_services → initialize` on each
  child correctly; controllers are constructed and owned by a context and
  reached only via injection; no code reaches across the tree for a
  controller.

## 2. New conformance gap — customer spawning bypasses the documented design

`NOTES.txt` and `ARCHITECTURE_REVIEW.md` §3 Phase 3 record a specific
decision: spawning is a **level-owned authority**, `CustomerSpawnerComponent`,
"analogous to `EntitySpawnController`." That component exists
(`features/components/customer/customer_spawner_component.gd`, fully
implemented — guarded `setup()`/`spawn()`, `customer_spawned` signal) and so
does `CustomerQueue`, but neither is referenced by any `.tscn` in the project.
What actually shipped instead: `PathController._ready()` hardcodes
`customer_scene.instantiate()` once, directly. It works for a single
always-present customer, but it's a different design than the one written
down, and `CustomerSpawnerComponent`/`CustomerQueue` are now dead code sitting
next to the thing that replaced them. Worth an explicit call: either wire the
spawner in (if multiple/timed customers are still the goal) or update
`NOTES.txt` to record the simpler design and remove the unused component.

**[DONE]**`RootContext` is also the one Context that doesn't implement `initialize()`
(only `build_services`/`bind_services`) — a small gap against "each context
implements the three-phase lifecycle." Functionally harmless since
`_ready()` + `request_start_game` cover the same timing, but worth either
adding a no-op `initialize()` for consistency or noting the exception in
`ARCHITECTURE.md`.

## 3. Bugs

1. **[DONE]`farm_plot.tscn` connects signals to methods that don't exist.** It has
   `[connection signal="area_entered" ... method="_on_area_entered"]` and the
   same for `area_exited`, but `farm_plot.gd` is just
   `class_name FarmPlot extends Area2D` — no methods at all. This will throw
   a "nonexistent function" error the moment the scene loads.
2. **[DONE]`customer_order_component.tscn` is broken and orphaned.** Its root node
   is `type="Node2D"`, but the attached script (`customer_order_component.gd`)
   declares `extends Control` — `Node2D` and `Control` aren't compatible, so
   this scene can't be instanced as-is. It's also unused: `frog_entity.tscn`
   builds its own inline `Control` node with the same script rather than
   instancing this scene (that appears to be a leftover from an earlier
   iteration — the frog scene used to `instance=ExtResource(...)` this exact
   file before switching to the inline node). Recommend deleting it, or fixing
   the root type and switching `frog_entity.tscn` back to instancing it if a
   reusable scene is preferred.
3. **`PathController.instance` is dead and `customer_finished` emits null.**
   `var instance: CharacterBody2D` is declared but never assigned anywhere;
   the actual spawned customer lives in `var customer`. `customer_finished.emit(instance)`
   in `_physics_process` therefore always emits `null` instead of the
   customer that reached the end of the path. Should be
   `customer_finished.emit(customer)`.
4. **`LevelContext.initialize()` initializes the overlay even when it never
   attached.** `level_overlay.initialize(_inventory_controller)` sits outside
   the `if player.has_node("Camera2D")` branch, so if the player has no
   `Camera2D` (or hasn't spawned), the overlay still runs `bind_events()` /
   `update_inventory()` on a `Control` that was never added to the tree —
   it'll silently do nothing visible instead of failing loudly. Move the
   `initialize()` call inside the successful-attach branch, or `push_warning`
   on the failure path.

## 4. Orphaned / dead code

- `CustomerSpawnerComponent`, `CustomerQueue` — not referenced by any scene (see §2).
- `customer_order_component.tscn` — not referenced by any other scene (see §3.2).
- `features/plants/plant.tres` — an empty, unconfigured `PlantData` resource
  (no `plant_name`/`scene`/`icon` set) sitting alongside `tomato.tres` and
  `potato.tres`; not referenced anywhere.
- `PlantEntity.Type` enum (`TOMATO`, `POTATO`) — declared, never read.
- `ActionComponent.num_created` — declared, never read or written past its
  `0` initializer.

## 5. Naming / style drift

- `PlantEntity.isHarvestable` is the only camelCase property in the codebase;
  everything else (`is_planting_enabled`, `customer_in_trade_area`,
  `trading_enabled`, `create_plant`, ...) is snake_case. Rename to
  `is_harvestable` for consistency with `ARCHITECTURE.md`'s otherwise
  consistent conventions.
- `CustomerOrderComponent.add_order()` builds icon paths by hand
  (`"res://assets/" + item + "_icon.png"`) instead of calling
  `InventoryIcons.get_icon("plants", item)`, which already centralizes that
  mapping and has a documented fallback (`push_warning` + `null`) for a
  missing icon. The hand-rolled version has neither.
- `CustomerOrderComponent.order` is declared as a plain `Dictionary`, but
  `get_order()` declares its return type as `Dictionary[String, int]`. Type
  `order` the same way so the return isn't relying on implicit coercion.
- `SeedEntry` and `PlantEntry` are near-identical scripts (same
  `_rescale_font`/`setup`/`set_count` logic, different class name). Not
  wrong today, but if a third entry type shows up, worth factoring into one
  shared `InventoryEntry` base.

## 6. Repo hygiene

- Phase 0's cleanup held: no `.tmp` files, no lingering `Global`/`SignalBus`/
  `Refs`/`NodeExtensions`/`Utils` code, no `*Manager` classes. The remaining
  hits for those names are all in explanatory comments.
- Working tree currently mixes staged and unstaged edits across ~10 tracked
  files plus two untracked new files (`customer_entity.gd`/`.uid`). Given how
  deliberately phased the git history is elsewhere in this project (see the
  Phase 0–3 commits), it's worth committing the current customer/trading work
  in its own logical chunk before more changes stack on top of it.

## 7. What's solid

The DI chain and lifecycle contract are genuinely well-executed —
`bind_services`/`build_services`/`initialize` is applied consistently and the
comments explain *why* at every non-obvious step (e.g. `InventoryController._typed_category`'s
note on GDScript's lack of nested generic dictionaries, or `GameStateHolder`
existing specifically so bound references survive a reset). `TradeArea` and
`TradingComponent`'s local-signal design is a clean replacement for the old
`SignalBus`. The HUD scaling approach in `hud_layer.gd` is unusually well
documented for a POC — the tradeoffs among the five options considered are
written down in `ARCHITECTURE.md`, not just implemented.

## 8. Suggested priority order

1. `farm_plot.tscn` broken signal connections — will error on load.
2. `customer_order_component.tscn` type mismatch — delete or fix.
3. `PathController.instance` → `customer` in the `customer_finished` emit.
4. Decide `CustomerSpawnerComponent`/`CustomerQueue`: wire in or remove, and
   update `NOTES.txt` either way.
5. `LevelContext.initialize()` — guard the overlay's `initialize()` call.
6. Cosmetic pass: `isHarvestable`, dead `Type` enum / `num_created`,
   `CustomerOrderComponent`'s icon lookup and `order` typing.
