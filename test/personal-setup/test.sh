#!/usr/bin/env bash
set -e

source dev-container-features-test-lib

check "starship is available"   bash -c "which starship"

reportResults