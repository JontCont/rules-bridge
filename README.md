# rules-bridge

> An Agent Skill that bridges your AI rule files to every tool you use.

`rules-bridge` reads your `AGENTS.md` (or `CLAUDE.md`) and automatically
converts it to the native configuration format expected by GitHub Copilot,
Cursor, and Codex CLI — all from a single slash command inside Claude Code.

---

## Supported Tools

| Tool             | Output path                        | Format                        |
|------------------|------------------------------------|-------------------------------|
| GitHub Copilot   | `.github/copilot-instructions.md`  | Plain Markdown                |
| Cursor           | `.cursor/rules/base.mdc`           | Markdown + YAML frontmatter   |
| Codex CLI        | `AGENTS.md` *(no conversion)*      | Native (read as-is)           |

---

## Installation

Add this skill to your Claude Code setup with:

```bash
npx skills add JontCont/rules-bridge
```

---

## Usage

Open Claude Code in your project root and run:

```
/rules-bridge [target]
```

### Targets

| Target    | Effect                                                          |
|-----------|-----------------------------------------------------------------|
| `all`     | Sync to **all** supported tools (default when omitted)          |
| `copilot` | Write `.github/copilot-instructions.md`                         |
| `cursor`  | Write `.cursor/rules/base.mdc` with `.mdc` YAML frontmatter     |
| `codex`   | Verify `AGENTS.md` exists (Codex CLI reads it natively)         |

### Examples

```bash
# Sync to every tool at once
/rules-bridge
/rules-bridge all

# Sync only to GitHub Copilot
/rules-bridge copilot

# Sync only to Cursor
/rules-bridge cursor

# Check Codex CLI compatibility
/rules-bridge codex
```

---

## How it works

1. **`SKILL.md`** — declares the skill metadata and triggers recognised by
   Claude Code (both English and Chinese keywords).
2. **`commands/rules-bridge.md`** — defines the `/rules-bridge` slash command
   and passes `$ARGUMENTS` to the conversion script.
3. **`scripts/convert.sh`** — the core logic: reads `AGENTS.md`, creates the
   required directories, and writes the converted files. Each step prints a
   `✅` success or `❌` failure status.

---

## Requirements

- An `AGENTS.md` file in the root of your project.
- Bash 3.2+ (compatible with the default shell on macOS and all major Linux
  distributions).
- Claude Code with Agent Skills support.

---

## Project structure

```
rules-bridge/
├── SKILL.md                   # Skill metadata & documentation
├── commands/
│   └── rules-bridge.md        # /rules-bridge slash-command definition
├── scripts/
│   └── convert.sh             # Conversion logic (copilot / cursor / codex / all)
├── README.md                  # This file
└── LICENSE                    # MIT
```

---

## Contributing

Pull requests and issues are welcome! Please open an issue before submitting a
large change so we can discuss the approach.

---

## License

[MIT](LICENSE) © John Conte