# Features

Numbered register of every end-user visible feature; a number is never
reused. Every feature is covered by tests listed in [TESTS.md](TESTS.md);
the guard `tests/docs-contract.sh` fails when a feature has no test.

- **F1 — Ready-to-use python build stage.** Python, pip and the full
  compile toolchain are preinstalled; builds run as an unprivileged build
  user with the writable work directory `/app` already in place. Use it as
  the build stage and [mwaeckerlin/python] as the minimal final stage.
- **F2 — System-module packaging helper.** Running `sh -c "$ADD_MODULES"`
  collects the python runtime and the native library dependencies of all
  installed modules into `/tmp/root`, ready to be copied into the shell
  free final image with a single `COPY --from=build /tmp/root /`.

[mwaeckerlin/python]: https://github.com/mwaeckerlin/python
