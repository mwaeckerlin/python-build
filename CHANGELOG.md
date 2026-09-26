# Changelog

- 2026-09-26 **1.0.2**
    - The image is published for amd64 and arm64 under one tag, built and published automatically on every change and every week

- 2026-07-28 **1.0.1**
    - The image builds again: it tried to recreate the work directory that its parent image already provides, which aborted every fresh build with "File exists"
    - Test suite added: contract checks for the interpreter, the installer, the unprivileged build user, the writable work directory and the module packaging helper
    - Feature and test registers added (FEATURES.md, TESTS.md) with an automatic guard: every feature must have a test, and no test may be skipped
