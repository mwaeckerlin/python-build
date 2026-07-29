# Tests

Register of all tests, grouped by kind and sorted by the
[FEATURES.md](FEATURES.md) number each test covers. `npm test` runs
everything; the guard `tests/docs-contract.sh` fails when a feature has no
test entry here or when any test carries a skip/xfail marker — tests are
never skipped.

## Image-/Compose-Contract-Tests

- **F1** `tests/config-contract.sh` › python3, pip — the interpreter and installer are present and executable.
- **F1** `tests/config-contract.sh` › unprivileged_build_user — the default user is not root.
- **F1** `tests/config-contract.sh` › app_workdir_writable — `/app` exists, is the working directory and is writable by the build user (regression: recreating the inherited `/app` aborted the build with "File exists").
- **F2** `tests/config-contract.sh` › add_modules_helper — `sh -c "$ADD_MODULES"` really populates `/tmp/root`.
