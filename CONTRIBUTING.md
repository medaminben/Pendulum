# Contributing to Pendulum

Bug reports, ideas and pull requests are welcome.

## Reporting bugs and asking for features

Open an [issue](https://github.com/medaminben/Pendulum/issues/new). For a bug,
say which program (`Pendulum_Console`, `Pendulum_Qt_UI` or the library), your
OS, compiler, CMake and Qt versions, and the steps that show it.

Do not report security problems in a public issue; [SECURITY.md](SECURITY.md)
explains how to report them privately.

## Making a change

1. Fork the repository and create a branch from `main`.
2. Build and run the tests:

   ```bash
   cmake --preset default
   cmake --build --preset default
   ctest --preset default --output-on-failure
   ```

3. Add or update tests for what you change. Test through the public API.
4. Update the documentation (`README.md`, `docs/architecture.md`,
   `libraries/Pendulum/README.md`) when behaviour, build options or the public
   API change.
5. Open a pull request against `main`.

`npm install` sets up the Git hooks:

- **pre-commit**: lint-staged runs clang-format on staged C++ files and a
  CMake style check.
- **commit-msg**: Commitlint checks the commit message.

## Code style

- C++20 without compiler extensions; warnings are errors on library and app
  targets.
- Format with clang-format (`.clang-format`, Google-based):
  `npm run format:check`.
- clang-tidy (`.clang-tidy`) runs in CI; locally use `-DENABLE_CLANG_TIDY=ON`.
- Public headers under `include/<Lib>/`, private code in `src/`.

| Item | Style |
|------|-------|
| Namespaces, types | `CamelCase` |
| Functions, variables | `lower_case` |
| Test executables | `test_*`, all lowercase |

Coverage with GCC and lcov:

```bash
cmake --preset coverage
cmake --build --preset coverage
cmake --build --preset coverage --target coverage
# open build/coverage/coverage/html/index.html
```

## Commits

Use [Conventional Commits](https://www.conventionalcommits.org/):
`type(scope): what changed`, for example `fix(pendulum): join worker on stop`.
Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`,
`build`, `ci`, `chore`, `revert`.

## Pull requests

CI checks formatting, commit messages, CMake style, and builds and tests with
GCC and Clang on Ubuntu. A pull request is merged once CI is green and a
maintainer has reviewed it.

## Code of conduct

Everyone taking part in this project follows the
[Code of Conduct](CODE_OF_CONDUCT.md).

## License

By contributing you agree that your contributions are licensed under the
[MIT License](LICENSE).
