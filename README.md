# vir-lang-skills

Agent Skills for the [Vir programming language](https://github.com/virgori/Vir-lang) (Virgori Labs).

Skills:

| Skill | Purpose |
|-------|---------|
| `vir-lang` | Vir **v2.0** syntax / stdlib / anti-hallucination for `.vri` |
| `virc-freeze` | Versioned **filesystem freezes** of stdlib+compiler for release & experiments (beyond git) |

## Quick install

### Recommended (skills.sh / Anthropic-style)

Works with Cursor, Claude Code, Codex, and [70+ agents](https://github.com/vercel-labs/skills):

```bash
npx skills add virgori/vir-lang-skills
```

Global install, non-interactive:

```bash
npx skills add virgori/vir-lang-skills --skill vir-lang --skill virc-freeze -g -y
```

Target specific agents:

```bash
npx skills add virgori/vir-lang-skills -g -y -a cursor -a codex -a claude-code
```

### One-liner (curl)

```bash
curl -fsSL https://raw.githubusercontent.com/virgori/vir-lang-skills/main/install.sh | bash
```

Project-local (`.cursor/skills`, `.agents/skills`):

```bash
curl -fsSL https://raw.githubusercontent.com/virgori/vir-lang-skills/main/install.sh | bash -s -- --project
```

## Layout

```text
skills/
├── vir-lang/
│   ├── SKILL.md
│   ├── references/
│   └── examples/
└── virc-freeze/
    ├── SKILL.md
    └── scripts/freeze_std_tree.sh   # mirrored from Vir tools/
```

In the Vir monorepo the live script is `tools/freeze_std_tree.sh` (writes under `frozen/`).

## Uninstall

```bash
npx skills remove vir-lang
npx skills remove virc-freeze
```

Or delete installed copies:

```bash
rm -rf ~/.cursor/skills/{vir-lang,virc-freeze} ~/.agents/skills/{vir-lang,virc-freeze} ~/.claude/skills/{vir-lang,virc-freeze}
```

## License

Apache-2.0 — see [LICENSE](LICENSE).
