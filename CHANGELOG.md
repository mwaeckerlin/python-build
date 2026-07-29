# Changelog

- 2026-07-28 **1.0.1**
    - The image builds again: it tried to recreate the work directory that its parent image already provides, which aborted every fresh build with "File exists"
    - Test suite added: contract checks for the interpreter, the installer, the unprivileged build user, the writable work directory and the module packaging helper
    - Feature and test registers added (FEATURES.md, TESTS.md) with an automatic guard: every feature must have a test, and no test may be skipped
