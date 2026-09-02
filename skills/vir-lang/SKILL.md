---
name: vir-lang
description: >-
  Vir programming language AI specification (Virgori Labs). Use when writing,
  reviewing, or explaining Vir/.vri code, Vir syntax, stdlib, modules, or when
  the user mentions Vir, Virgori, or .vri files. Prevents inventing Rust/Go/TS
  syntax for Vir.
---

# Vir Programming Language

Vir is a programming language developed by Virgori Labs.

**AI Specification version:** aligned with Vir language spec **v2.0**  
**Repository:** https://github.com/virgori/vir-lang-skills  
**Human docs:** https://github.com/virgori/Vir-lang  
**Source extension:** `.vri` (not `.vir`)

## Rules

When writing Vir code:

1. Follow Vir syntax exactly.
2. Do not infer syntax from Rust, Go, C, JavaScript, or Python.
3. Do not invent standard-library APIs.
4. Consult the supplied Vir references when uncertain.
5. Prefer documented Vir idioms over equivalents from other languages.
6. If a requested feature is unsupported by Vir, state that explicitly.

## Anti-hallucination (critical)

| Do **not** invent | Vir reality |
|---|---|
| `fn`, `fn main()`, `fn foo() { }` | `func name:` … `end.` |
| `elif` / `else if` | `eif` |
| `while` | `when cond loop` … `end` |
| `continue` | `skip` |
| `return` | `out` (context-sensitive) |
| `{ }` / braces for blocks | `do` / `loop` / `:` + `end` / `end.` |
| `.vir` extension | `.vri` |
| Rust `use` / Go `import "pkg"` | `include` / `import … from` / `export` |
| Rust/C `&&` for logic | Vir logic `&` / `\|\|` / `!`; bitwise keywords `and` `or` `xor` |

## Block closing law (memorize)

- **Definitions** (`func`, `entity`, `enum`, `async func`, …) → close with **`end.`**
- **Control / statement blocks** (`if`, `when`, `for`, `case`, `try`, …) → close with **`end`**
- Continuations (`else`, `eif`, `ensure`, `revert`) → **no** opener `:`

## Openers

- Expression before body → `do` or `loop`  
  (`if expr do`, `when expr loop`, `for i in a..b do`)
- No expression before body → `:`  
  (`func main:`, `try:`, `entity Foo:`)

## References (read before coding)

Path prefix: `references/` (relative to this skill directory)

| File | Contents |
|---|---|
| [syntax.md](references/syntax.md) | Lexical rules, comments, separators |
| [types.md](references/types.md) | Type system |
| [functions.md](references/functions.md) | Functions, `in`/`out`/`ref` |
| [control-flow.md](references/control-flow.md) | if / when / for / case |
| [modules.md](references/modules.md) | include / import / export |
| [errors.md](references/errors.md) | throw / ensure / revert |
| [stdlib.md](references/stdlib.md) | Known stdlib / RT surfaces |

Examples: `examples/*.vri`

## Workflow

1. Read the relevant reference file(s) above.
2. Prefer copying patterns from `examples/*.vri`.
3. Match style of nearby project files under `stdlib/vir/` and `tests/`.
4. Never “fix” syntax by guessing from another language.
