#!/usr/bin/env bash

# Forge-Up aggregator: source all modules in deterministic order.
# Usage: source forgeup.sh  (must be bash)

# Require bash
if [ -z "${BASH_VERSION:-}" ]; then
    echo "Forge-Up: please source with bash (current shell: $SHELL)" >&2
    return 1 2>/dev/null || exit 1
fi

# # Guard (defined only after successful load)
# if [ -n "${FORGEUP_LOADED:-}" ]; then
#     echo "Forge-Up: already loaded." >&2
#     return 0
# fi

# Resolve repo root independent of caller's CWD
# command cd to ensure no shell built-in cd is aliased e.g. with pushd/popd or zoxide
FORGEUP_ROOT="$(command cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Ordered modules (logging first for messages)
FORGEUP_MODULES=(
    lib/logging.sh
    lib/core.sh
    lib/gh_install.sh
    lib/installers.sh
    lib/apt.sh
    lib/services.sh
    lib/vim.sh
    lib/tmux.sh
    lib/dotfiles.sh
)

for mod in "${FORGEUP_MODULES[@]}"; do
    full="${FORGEUP_ROOT}/${mod}"
    if [ -f "$full" ]; then
        # shellcheck source=/dev/null
        . "$full"
    else
        echo "Forge-Up: missing module $full" >&2
    fi
done

FORGEUP_VERSION="$(cat "${FORGEUP_ROOT}/VERSION" 2>/dev/null || echo "dev")"
FORGEUP_LOADED=1
