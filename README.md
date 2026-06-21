# Chat Reply Workspace Template

A local-first workspace template for analyzing chat context, maintaining relationship-specific notes, and drafting replies in a consistent personal voice.

The structure separates:

- global self profile and communication style in `me/`
- per-person relationship files in `people/<alias>/`
- explicit visible persona from speculative unconscious/dynamic hypotheses
- reusable rules in `AGENTS.md`

## Privacy Model

This template is designed for private use. Do not commit real chat logs, screenshots, names, phone numbers, account IDs, or sensitive relationship notes to a public repository.

By default, `.gitignore` tracks only `people/_template/` and ignores real `people/<alias>/` directories.

## Directory Layout

```text
.
├── AGENTS.md
├── me/
│   ├── profile.md
│   ├── style.md
│   ├── unconscious.md
│   └── cases.md
└── people/
    └── _template/
        ├── profile.md
        ├── persona.md
        ├── unconscious.md
        ├── style.md
        └── cases.md
```

## Usage

1. Copy `people/_template/` to `people/<alias>/`.
2. Put only an alias in the folder name.
3. Paste new chat context into your assistant session.
4. Let the assistant update the relevant files after you confirm an observation should be persisted.

## License

MIT
