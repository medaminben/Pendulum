# Pendulum library

`Pendulum::Pendulum` (raw target `pendulum`, namespace `Pendulum`) simulates a simple pendulum.
It has no UI and no rendering code. The applications read the bob position and
draw it.

## Public headers

| Header | Contents |
|--------|----------|
| `<Pendulum/Pendulum.h>` | `Simulator`: set up, step, run on a thread, read the position |
| `<Pendulum/Constants.h>` | `gravity`, `fps`, and the scene size `width` × `height` (2736 × 2192 px) |
| `<Pendulum/Pendulum_export.h>` | `PENDULUM_API` export macro, generated in the build tree |

## Model

- The pin is fixed at `Simulator::pin_point()`: the horizontal centre of the
  scene, 1% of its height from the top.
- The constructor takes the bob position in scene pixels. The rod length and
  the start angle follow from it; the bob starts at rest.
- 100 scene pixels are 1 metre. `gravity` is 9.8 m/s².
- One `step()` advances by 1/`fps` s (1/60 s) with semi-implicit Euler: angular
  velocity first, then the angle. There is no damping; `damp` in
  `Constants.h` is not used.
- `start()` runs `step()` on a worker thread, sleeping about 15 ms between
  steps, so simulated time runs slightly faster than wall time.

## Threading

- `start()` stops a running worker before starting a new one.
- `set_hold(true)` ends the worker loop. `set_hold(false)` alone does not
  restart it; call `start()` again.
- The destructor stops and joins the worker.
- `position()` reads plain floats that the worker writes. Reading while the
  worker runs is a data race; see the open issue in
  [docs/architecture.md](../../docs/architecture.md#known-issues).
- Do not call `step()` while the worker runs.

## Dependencies

| Allowed | Forbidden |
|---------|-----------|
| C++ standard library, `Threads::Threads` (private) | Qt and any other UI or rendering library |

## Tests

```bash
cmake --preset default
cmake --build --preset default
ctest --preset default --output-on-failure
```

The tests in `test/src/test_Pendulum.cpp` cover the pin point, the start
position and that one `step()` moves the bob. They run as `test_pendulum`
with the `unit` label.
