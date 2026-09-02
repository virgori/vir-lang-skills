#!/usr/bin/env bash
# Install vir-lang agent skill from GitHub (Cursor, Codex, Claude, …)
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/virgori/vir-lang-skills/main/install.sh | bash
#   curl -fsSL …/install.sh | bash -s -- --project
#   curl -fsSL …/install.sh | bash -s -- --global
set -euo pipefail

REPO="${VIR_LANG_SKILLS_REPO:-virgori/vir-lang-skills}"
BRANCH="${VIR_LANG_SKILLS_BRANCH:-main}"
SKILL_NAME="vir-lang"
SKILL_PATH="skills/${SKILL_NAME}"
SCOPE="global"
USE_NPX=1

usage() {
  cat <<'EOF'
vir-lang-skills installer

  curl -fsSL https://raw.githubusercontent.com/virgori/vir-lang-skills/main/install.sh | bash

Options (pass after bash -s --):
  --project     Install into current repo (.cursor/skills, .agents/skills, .claude/skills)
  --global      Install into user home (default)
  --no-npx      Skip npx skills add; always git clone + copy
  -h, --help    Show this help

Environment:
  VIR_LANG_SKILLS_REPO    GitHub repo (default: virgori/vir-lang-skills)
  VIR_LANG_SKILLS_BRANCH  Branch (default: main)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) SCOPE="project"; shift ;;
    --global)  SCOPE="global"; shift ;;
    --no-npx)  USE_NPX=0; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

install_with_npx() {
  command -v npx >/dev/null 2>&1 || return 1
  local -a args=(skills add "$REPO" --skill "$SKILL_NAME" -y)
  if [[ "$SCOPE" == "global" ]]; then
    args+=(-g)
  fi
  # Best-effort: common agents; skills CLI ignores unknown agents.
  args+=(-a cursor -a codex -a claude-code)
  echo "→ npx ${args[*]}"
  npx -y "${args[@]}"
}

destinations() {
  if [[ "$SCOPE" == "project" ]]; then
    printf '%s\n' \
      ".cursor/skills/${SKILL_NAME}" \
      ".agents/skills/${SKILL_NAME}" \
      ".claude/skills/${SKILL_NAME}"
  else
    printf '%s\n' \
      "${HOME}/.cursor/skills/${SKILL_NAME}" \
      "${HOME}/.agents/skills/${SKILL_NAME}" \
      "${HOME}/.claude/skills/${SKILL_NAME}"
  fi
}

install_with_git() {
  local tmp dest src
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT

  echo "→ git clone --depth 1 https://github.com/${REPO}.git (${BRANCH})"
  git clone --depth 1 --branch "$BRANCH" "https://github.com/${REPO}.git" "${tmp}/repo"

  src="${tmp}/repo/${SKILL_PATH}"
  if [[ ! -f "${src}/SKILL.md" ]]; then
    echo "error: ${SKILL_PATH}/SKILL.md not found in ${REPO}" >&2
    exit 1
  fi

  while IFS= read -r dest; do
    mkdir -p "$(dirname "$dest")"
    rm -rf "$dest"
    cp -R "$src" "$dest"
    echo "✓ ${dest}"
  done < <(destinations)
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
