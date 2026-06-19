# Architecture

GrowthMindsetPOC uses a **Context / Controller / Component** structure with manual
dependency injection and no global singletons (no autoloads). Dependencies flow
**down** the scene tree via `bind_services`; events flow **up** via signals.

## Roles

**Context** — a scene-tree composition root that owns one lifecycle stage and the
scene below it. Contexts form a chain: `RootContext → GameContext → LevelContext`.
Each context implements the three-phase lifecycle and drives the same lifecycle on
the child context it instantiates.

**Controller** — an injected, stateful logic service (`extends Node`). Operates on
game state and exposes `bind_services(...)` plus domain methods. Examples:
`GameController`, `InventoryController`, `EntitySpawnController`. Controllers are
built and owned by a context, never reached through globals.

**Holder** — `GameStateHolder` wraps a swappable `GameState`. The holder reference
stays stable across resets; the state object inside it is replaceable. Bind the
holder, not the state, so references survive a reset.

**Component** — a stateless behavior unit (`extends Node`) attached to an entity and
called by that entity. The `Player` entity composes `InputComponent`,
`MovementComponent`, `ActionComponent`, `HarvestingComponent`, `TradingComponent`
and orchestrates them in `_input` / `_physics_process`.

**Entity** — an in-world `CharacterBody2D` / `Area2D` (e.g. `Player`, `PlantEntity`,
customers). Entities compose Components; they do not contain game-wide logic.

**Overlay** — the UI layer (`GameOverlay`). Has its own `initialize(controller)` that
injects a controller into UI sub-views (`SeedsBox`, `PlantsBox`), which follow
`initialize → bind_services → bind_events`.

**Data** — a `Resource` definition (e.g. `PlantData`, `Tomato extends PlantData`).
Pure data, no scene behavior.

## Lifecycle contract (Contexts)

```
build_services()   # instantiate the services/controllers this context owns
bind_services(...) # receive dependencies from the parent (hand-written injection)
initialize()       # connect signals and start behavior
```

A parent context instantiates the child scene, then calls
`build_services() → bind_services(...) → initialize()` on it, in that order.

## Naming & folder conventions

- Suffix `Component` for stateless entity behaviors; **do not** use `Handler`.
- Suffix `Controller` for injected logic services; `Context` for lifecycle roots;
  `Entity`/`Data` for in-world nodes / resources.
- Stateless components live in `features/components/` (shared) or beside their entity
  (e.g. `features/player/input_component.gd`).
- One `class_name` per role; avoid reusing a role word for a different role
  (e.g. an in-world plant is `PlantEntity`, the resource is `PlantData`).

## Do not

- Reintroduce global singletons (`Global`, `SignalBus`, `Refs`, `NodeExtensions`,
  `Utils`) or `*Manager` autoloads. Inject dependencies instead.
- Reach across the tree for a controller; receive it through `bind_services`.

See `ARCHITECTURE_REVIEW.md` for the current conformance audit and the phased plan.
Open design questions live in `NOTES.txt`.
