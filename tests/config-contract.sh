#!/usr/bin/env bash
# Config contract: the shipped build image must be ready to build python
# software as an unprivileged user.
#
# The checks run the shipped binaries themselves. `--pull=never` keeps
# docker from silently pulling a stale image from the registry when the
# local build is missing; that would test the wrong artefact.
#
# Usage: tests/config-contract.sh IMAGE

set -uo pipefail

IMAGE="${1:?usage: tests/config-contract.sh IMAGE}"

PASS=0
FAIL=0
declare -a FAILED_NAMES

_pass() { PASS=$((PASS + 1)); echo "  PASS  $1"; }
_fail() { FAIL=$((FAIL + 1)); FAILED_NAMES+=("$1"); echo "  FAIL  $1: $2"; }

echo "==> Config contract: python build environment"

if ! docker image inspect "${IMAGE}" > /dev/null 2>&1; then
    _fail "${IMAGE}_image_exists" "image not built — run 'npm run build' first"
else
    if docker run --rm --pull=never --entrypoint /usr/bin/python3 "${IMAGE}" --version > /dev/null 2>&1; then
        _pass "${IMAGE}_python3"
    else
        _fail "${IMAGE}_python3" "python3 missing or not executable"
    fi

    if docker run --rm --pull=never --entrypoint /usr/bin/pip "${IMAGE}" --version > /dev/null 2>&1; then
        _pass "${IMAGE}_pip"
    else
        _fail "${IMAGE}_pip" "pip missing or not executable"
    fi

    USER_OUT=$(docker run --rm --pull=never --entrypoint /usr/bin/whoami "${IMAGE}" 2>&1)
    if [[ "${USER_OUT}" != "root" && -n "${USER_OUT}" ]]; then
        _pass "${IMAGE}_unprivileged_build_user"
    else
        _fail "${IMAGE}_unprivileged_build_user" "default user is '${USER_OUT}'"
    fi

    # Regression (2026-07-28): /app comes from the parent image; it must
    # exist, be the working directory and be writable by the build user.
    if docker run --rm --pull=never --entrypoint /bin/sh "${IMAGE}" -c 'test "$PWD" = /app && test -w /app' > /dev/null 2>&1; then
        _pass "${IMAGE}_app_workdir_writable"
    else
        _fail "${IMAGE}_app_workdir_writable" "/app missing, not the workdir or not writable"
    fi

    # The ADD_MODULES helper must actually collect the python runtime.
    if docker run --rm --pull=never --entrypoint /bin/sh "${IMAGE}" -c 'sh -c "$ADD_MODULES" && test -d /tmp/root/usr/lib' > /dev/null 2>&1; then
        _pass "${IMAGE}_add_modules_helper"
    else
        _fail "${IMAGE}_add_modules_helper" "ADD_MODULES did not populate /tmp/root"
    fi
fi

echo ""
echo "==> Config contract results: ${PASS} passed, ${FAIL} failed"
if [[ ${FAIL} -gt 0 ]]; then
    echo "==> Failed contracts: ${FAILED_NAMES[*]}"
    exit 1
fi
