# vir-lang-skills

Agent Skills for the [Vir programming language](https://github.com/virgori/Vir-lang) (Virgori Labs).

Teaches coding agents Vir **v2.0** syntax, stdlib surfaces, and anti-hallucination rules so they do not invent Rust/Go/TypeScript patterns for `.vri` files.

## Quick install

### Recommended (skills.sh / Anthropic-style)

Works with Cursor, Claude Code, Codex, and [70+ agents](https://github.com/vercel-labs/skills):

```bash
npx skills add virgori/vir-lang-skills
```

Global install, non-interactive:

```bash
npx skills add virgori/vir-lang-skills --skill vir-lang -g -y
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
skills/vir-lang/
├── SKILL.md           # Agent instructions + YAML frontmatter
├── references/        # Compact language facts (syntax, types, modules, …)
└── examples/          # Idiomatic .vri samples
```

## Uninstall

```bash
npx skills remove vir-lang
```

Or delete installed copies:

```bash
rm -rf ~/.cursor/skills/vir-lang ~/.agents/skills/vir-lang ~/.claude/skills/vir-lang
```

## License

Apache-2.0 — see [LICENSE](LICENSE).
