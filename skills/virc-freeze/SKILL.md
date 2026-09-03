---
name: virc-freeze
description: >-
  Freeze Vir compiler and stdlib into versioned filesystem trees for release
  and isolated experiments (beyond git tags). Use when releasing, pinning a
  std source snapshot, comparing freezes, or when the user mentions freeze
  directory, frozen/, release tree, or experimental std pin.
---

# virc-freeze — Filesystem pins for compiler + std

Git tags record **history**. Freezes record a **runnable directory pin** you can
point a release build or experiment at without depending on a dirty working tree.

## When to use

| Goal | Kind | Example |
|------|------|---------|
| Ship / archive a known-good std+compiler | `release` | `frozen/release/v2.2.0/` |
| Try heap/MIR changes without touching live std | `experimental` | `frozen/experimental/heap-2gb/` |
| Reproducible promote / fixed-point against a pin | either | `--with-bin --with-expanded` |

**Do not** treat a freeze as a substitute for git. Always keep the commit SHA in `MANIFEST.json`.

## Layout (canonical)

```text
frozen/
├── release/
│   └── v2.2.0/
│       ├── MANIFEST.json
│       ├── SHA256SUMS
│       ├── README.md
│       ├── stdlib/                 # full stdlib/ copy
│       ├── compiler_src/
│       │   ├── stdlib_vir_compiler/
│       │   ├── virc_stage1.vri     # if present
│       │   └── virc_boot.vri
│       ├── bin/virc                # optional (--with-bin)
│       └── virc-expanded.vri       # optional (--with-expanded)
└── experimental/
    └── <slug>/
        └── …same shape…
```

Default root: `frozen/` (gitignored). Override with `VIR_FREEZE_ROOT`.

## Agent rules

1. **Create freezes via** `bash tools/freeze_std_tree.sh` — do not hand-copy ad hoc trees.
2. **Never edit** `frozen/release/*` in place. For bugs: fix live tree → new freeze (or experimental).
3. **Experimental** freezes may be replaced with `--force`; **release** freezes need `--force` and an explicit user ask.
4. When promoting / self-hosting against a pin, prefer:
   - `--with-bin` (signed `-i virc-bootstrap`)
   - `--with-expanded`
   - then `verify`
5. Signed fixed-point compares use `codesign -i virc-bootstrap` (same as Stage-1 gate).
6. After freeze, report: path, git commit from MANIFEST, file counts, whether readonly.

## Commands

```bash
# Release pin
bash tools/freeze_std_tree.sh release v2.2.0 --with-bin --with-expanded --readonly

# Experiment pin (mutable by default)
bash tools/freeze_std_tree.sh experimental heap-2gb --with-bin --force

# Inventory / integrity
bash tools/freeze_std_tree.sh list
bash tools/freeze_std_tree.sh verify frozen/release/v2.2.0
```

## Using a freeze

- **Docs / packaging:** treat `frozen/release/<ver>/stdlib` as the std source of truth for that version.
- **Experiment:** `VIR_STDLIB_ROOT=frozen/experimental/<slug>/stdlib` (when tooling supports it) or copy paths into a worktree — do not mutate release pins.
- **Binary:** `frozen/.../bin/virc` after `--with-bin`.

## Anti-patterns

| Bad | Good |
|-----|------|
| “Frozen” = only a git tag | Tag **and** `freeze_std_tree.sh release …` |
| Edit `frozen/release/vX` to hotfix | Fix live → new patch freeze `vX.Y.Z` |
| Commit multi‑GB trees into git | Keep under `frozen/` (ignored); ship tarball/Release asset |
| Compare signed bins without fixed `-i` | `codesign -i virc-bootstrap` then `cmp` |

## Related

- Promote: `tools/promote_virc.sh` → `dist/virc-next`
- Native bin workflow: `.cursor/rules/virc-native-bin-workflow.mdc`
- Stage1 freeze (thin bootstrap): `virc_stage1.vri` is separate; use `--with-stage1` only when needed
