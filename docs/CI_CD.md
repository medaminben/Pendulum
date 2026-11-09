# CI / CD

The workflows call [buildkit](https://github.com/medaminben/buildkit)'s reusable workflows at `v2.0.0`. Their
inputs and behaviour are described in buildkit's
[CI/CD guide](https://github.com/medaminben/buildkit/blob/main/docs/CI_CD.md).

## Workflows

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| `ci.yml` | push to `main` and `feature/**`, pull requests to `main` | Lint (clang-format, CMake style, commitlint), build and test the `ci` and `qt` presets with GCC and Clang, the `asan` preset, clang-tidy and cppcheck (report only) |
| `codeql.yml` | push and pull requests to `main` | CodeQL analysis of the `default` preset |
| `release.yml` | pull request merged into `main` | Tags the merge commit and creates the GitHub release |

Coverage is off in `ci.yml`: buildkit `v2.0.0`'s coverage target stops on lcov
2's "inconsistent" error with GCC 15. It is turned on again once buildkit
ignores that error.

## Releases

Each merged pull request is released. Its label sets the version bump:
`semver:major`, `semver:minor`, `semver:patch` (the default) or `semver:none`
(no release). The first release is `v0.1.0`. The release notes are the commit
subjects since the previous tag. `CMakeLists.txt` reads the version from the
latest `vX.Y.Z` tag; without tags it is `0.1.0-dev`.

## Presets

| Preset | Use |
|--------|-----|
| `default` | Release build |
| `qt` | Release build with the Qt viewer |
| `debug` | Debug build |
| `coverage` | Debug build with gcov; `--target coverage` writes the HTML report |
| `asan` | Debug build with AddressSanitizer and UndefinedBehaviorSanitizer |
| `ci` | Release build used by CI |

All presets use Ninja and build into `build/<preset>`.

## Local checks

```bash
cmake --preset ci
cmake --build --preset ci
ctest --preset ci

npm install            # commit hooks
npm run format:check
```
