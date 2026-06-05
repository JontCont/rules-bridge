#!/usr/bin/env bash
# scripts/convert.sh
# Converts AGENTS.md to the native rule format of each supported AI tool.
#
# Usage:
#   bash scripts/convert.sh [copilot|cursor|codex|all]
#
# Targets:
#   copilot  → .github/copilot-instructions.md  (plain Markdown copy)
#   cursor   → .cursor/rules/base.mdc            (.mdc with YAML frontmatter)
#   codex    → AGENTS.md                         (verify only; natively supported)
#   all      → all three targets above           (default)

set -euo pipefail

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

SOURCE_FILE="AGENTS.md"

info()    { echo "$*"; }
success() { echo "✅ $*"; }
failure() { echo "❌ $*"; }

# ---------------------------------------------------------------------------
# Check that the source file exists
# ---------------------------------------------------------------------------

if [[ ! -f "${SOURCE_FILE}" ]]; then
  failure "Source file '${SOURCE_FILE}' not found in the current directory ($(pwd))."
  echo "   Please run this script from the project root, or create an AGENTS.md file first."
  exit 1
fi

# ---------------------------------------------------------------------------
# Conversion functions
# ---------------------------------------------------------------------------

convert_copilot() {
  local dest_dir=".github"
  local dest_file="${dest_dir}/copilot-instructions.md"

  if mkdir -p "${dest_dir}" && cp "${SOURCE_FILE}" "${dest_file}"; then
    success "copilot  → ${dest_file}"
  else
    failure "copilot  → Failed to write '${dest_file}'"
    return 1
  fi
}

convert_cursor() {
  local dest_dir=".cursor/rules"
  local dest_file="${dest_dir}/base.mdc"

  if ! mkdir -p "${dest_dir}"; then
    failure "cursor   → Failed to create directory '${dest_dir}'"
    return 1
  fi

  # Write .mdc file with required YAML frontmatter
  {
    echo "---"
    echo "alwaysApply: true"
    echo "---"
    echo ""
    cat "${SOURCE_FILE}"
  } > "${dest_file}"

  if [[ $? -eq 0 ]]; then
    success "cursor   → ${dest_file}"
  else
    failure "cursor   → Failed to write '${dest_file}'"
    return 1
  fi
}

convert_codex() {
  # Codex CLI reads AGENTS.md natively — just verify it exists.
  if [[ -f "${SOURCE_FILE}" ]]; then
    success "codex    → ${SOURCE_FILE} (already present; Codex CLI reads it natively)"
  else
    failure "codex    → '${SOURCE_FILE}' not found"
    return 1
  fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

TARGET="${1:-all}"

case "${TARGET}" in
  copilot)
    convert_copilot
    ;;
  cursor)
    convert_cursor
    ;;
  codex)
    convert_codex
    ;;
  all)
    info "Syncing rules to all supported tools..."
    errors=0
    convert_copilot || ((errors++)) || true
    convert_cursor  || ((errors++)) || true
    convert_codex   || ((errors++)) || true
    echo ""
    if [[ ${errors} -eq 0 ]]; then
      success "All targets synced successfully."
    else
      failure "${errors} target(s) failed. See messages above."
      exit 1
    fi
    ;;
  *)
    failure "Unknown target: '${TARGET}'"
    echo "   Valid targets: copilot, cursor, codex, all"
    exit 1
    ;;
esac
