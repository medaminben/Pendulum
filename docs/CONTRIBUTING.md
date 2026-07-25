# Contributing

## Setup

```bash
cmake --preset default
cmake --build --preset default
ctest --preset default

# Git hooks (format + commit lint)
npm install
```

Hooks:

- **pre-commit** — lint-staged runs clang-format on staged C++ files and a light CMake style check
- **commit-msg** — Commitlint enforces Conventional Commits

## Coding standards

- C++20, no compiler extensions (`CMAKE_CXX_EXTENSIONS OFF`)
- Format with clang-format (Google-based style in `.clang-format`)
- Static analysis via `.clang-tidy` (optional locally: `-DENABLE_CLANG_TIDY=ON`)
- Warnings are errors on library and app targets

### Naming

| Item | Style |
|------|-------|
| Namespaces / types | `CamelCase` |
| Functions / variables | `lower_case` |
| Test executables | `test_*` and fully lowercase |
| Test cases | `TEST(test_<lib>_<Area>, Behavior)` |

## Testing

Every library should ship tests under `libraries/<Lib>/test/`.

```bash
ctest --preset default --output-on-failure
ctest --preset default -L unit
```

Prefer testing through the **public API**. Add edge cases when changing behavior.

Coverage (GCC/Clang + lcov):

```bash
cmake --preset coverage
cmake --build --preset coverage
cmake --build --preset coverage --target coverage
# open build/coverage/coverage/html/index.html
```

## Commit messages

Format:

```
<type>(optional-scope): <description>

[optional body]
```

Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

Examples:

```
feat(core): add clamp helper
fix(build): pin googletest to v1.15.2
docs: describe scaffold workflow
ci: add CodeQL analyze step
```

## Pull request checklist

- [ ] Builds with `cmake --preset default`
- [ ] Tests pass (`ctest --preset default`)
- [ ] New/changed public API has tests
- [ ] clang-format clean (`npm run format:check` if available)
- [ ] Commit messages are conventional
- [ ] Docs updated when behavior or workflow changes

## Security

- Do not commit secrets, machine-local Qt paths, or `cmake/configs/env_vars.ini`
- Prefer pinned FetchContent tags over branch names (`main`/`master`)
- Run / respect CI security jobs (cppcheck, CodeQL) before merging risky changes
