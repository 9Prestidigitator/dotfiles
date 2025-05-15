#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
    printf "Usage: %s <config_file>\n" "$0" >&2
    exit 1
fi

CONFIG="$1"

if [[ ! -f "$CONFIG" ]]; then
    printf "Config file not found: %s\n" "$CONFIG" >&2
    exit 1
fi

# Load configuration
# shellcheck disable=SC1090
source "$CONFIG"

for pkg in "${DEV_TOOLS[@]}"; do
    printf "Would install: %s\n" "$pkg"
done

