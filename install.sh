#!/usr/bin/env bash
# Install vir-lang-skills (all skills under skills/) from GitHub
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/virgori/vir-lang-skills/main/install.sh | bash
#   curl -fsSL …/install.sh | bash -s -- --project
#   curl -fsSL …/install.sh | bash -s -- --skill virc-freeze
set -euo pipefail

REPO="${VIR_LANG_SKILLS_REPO:-virgori/vir-lang-skills}"
BRANCH="${VIR_LANG_SKILLS_BRANCH:-main}"
SCOPE="global"
USE_NPX=1
# empty = all skills
SKILL_FILTER=""

usage() {
  cat <<'EOF'
vir-lang-skills installer

  curl -fsSL https://raw.githubusercontent.com/virgori/vir-lang-skills/main/install.sh | bash

Options (pass after bash -s --):
  --project           Install into current repo (.cursor/skills, …)
  --global            Install into user home (default)
  --skill <name>      Install only one skill (repeatable intent: pass once)
  --no-npx            Skip npx skills add; always git clone + copy
  -h, --help          Show this help

Environment:
  VIR_LANG_SKILLS_REPO    GitHub repo (default: virgori/vir-lang-skills)
  VIR_LANG_SKILLS_BRANCH  Branch (default: main)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) SCOPE="project"; shift ;;
    --global)  SCOPE="global"; shift ;;
    --skill)   SKILL_FILTER="$2"; shift 2 ;;
    --no-npx)  USE_NPX=0; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

dest_for() {
  local name="$1"
  if [[ "$SCOPE" == "project" ]]; then
    printf '%s\n' \
      ".cursor/skills/${name}" \
      ".agents/skills/${name}" \
      ".claude/skills/${name}"
  else
    printf '%s\n' \
      "${HOME}/.cursor/skills/${name}" \
      "${HOME}/.agents/skills/${name}" \
      "${HOME}/.claude/skills/${name}"
  fi
}

install_with_npx() {
  command -v npx >/dev/null 2>&1 || return 1
  local -a args=(skills add "$REPO" -y)
  if [[ -n "$SKILL_FILTER" ]]; then
    args+=(--skill "$SKILL_FILTER")
  else
    args+=(--skill '*')
  fi
  if [[ "$SCOPE" == "global" ]]; then
    args+=(-g)
  fi
  args+=(-a cursor -a codex -a claude-code)
  echo "→ npx ${args[*]}"
  npx -y "${args[@]}"
}

_CLEANUP_TMP=""

cleanup_tmp() {
  if [[ -n "${_CLEANUP_TMP}" && -d "${_CLEANUP_TMP}" ]]; then
    rm -rf "${_CLEANUP_TMP}"
  fi
}

install_with_git() {
  local dest src name
  _CLEANUP_TMP="$(mktemp -d)"
  trap cleanup_tmp EXIT

  echo "→ git clone --depth 1 https://github.com/${REPO}.git (${BRANCH})"
  git clone --depth 1 --branch "$BRANCH" "https://github.com/${REPO}.git" "${_CLEANUP_TMP}/repo"

  for src in "${_CLEANUP_TMP}/repo/skills"/*; do
    [[ -d "$src" ]] || continue
    name="$(basename "$src")"
    if [[ -n "$SKILL_FILTER" && "$name" != "$SKILL_FILTER" ]]; then
      continue
    fi
    [[ -f "${src}/SKILL.md" ]] || continue
    while IFS= read -r dest; do
      mkdir -p "$(dirname "$dest")"
      rm -rf "$dest"
      cp -R "$src" "$dest"
      echo "✓ ${dest}"
    done < <(dest_for "$name")
  done
}

main() {
  echo "vir-lang-skills installer (scope: ${SCOPE})"
  if [[ "$USE_NPX" -eq 1 ]] && install_with_npx; then
    echo "✓ installed via npx skills"
    return 0
  fi
  install_with_git
  echo "✓ installed via git copy"
}

main
