# CI / CD

## Pipelines

### Continuous integration — `.github/workflows/ci.yml`

Triggers: push and pull request to `main` / `master` / `develop`.

| Job | Purpose |
|-----|---------|
| **Format** | `clang-format --dry-run --Werror` on tracked C++ sources |
| **Lint** | Commitlint (PR range), CMake style script, optional clang-tidy |
| **Build & Test** | Matrix: GCC and Clang via `cmake --preset ci` + `ctest` |
| **Coverage** | GCC job builds `coverage` target and uploads HTML + lcov artifacts |
| **Qt UI** | Builds and tests with `ci-qt` (Qt 6), then installs the package tree |
| **Security** | cppcheck (advisory) + CodeQL analyze |

### Release — `.github/workflows/release.yml`

Trigger: push tag matching `v*` (example: `v1.0.0`).

1. Configure the `qt` preset (Qt 6) with an install prefix
2. Build and test
3. `cmake --install`
4. Pack `pendulum-<tag>-linux-amd64.tar.gz`
5. Create GitHub Release with notes + artifact

```bash
git tag -a v1.0.0 -m "chore(release): v1.0.0"
git push origin v1.0.0
```

## Local parity

```bash
# same preset CI uses
cmake --preset ci
cmake --build --preset ci --parallel
ctest --preset ci --output-on-failure

# or helper script
./scripts/ci-build.sh ci
```

Format / commit checks (needs Node + clang-format):

```bash
npm install
npm run format:check
npx commitlint --from origin/master --to HEAD --verbose
```

## Presets

| Preset | Use |
|--------|-----|
| `default` | Release build (Unix Makefiles) |
| `qt` | `default` + `BUILD_QT_UI` |
| `ninja` | Release with Ninja |
| `debug` | Debug symbols |
| `coverage` | Debug + `ENABLE_COVERAGE` |
| `ci` | RelWithDebInfo + coverage flags |
| `ci-qt` | `ci` + `BUILD_QT_UI` |

## Artifacts

CI may upload:

- `coverage-report` — HTML from genhtml
- `coverage-lcov` — filtered `coverage.filtered.info`

Release uploads the install tarball to the GitHub Release.

## Secrets

No custom secrets are required for the default workflows. Releases use `GITHUB_TOKEN` provided by Actions.
