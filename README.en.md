# TalkTrace

[中文版本](README.md)

A local workspace for organizing conversations, understanding relationship positions, and training a more natural way of speaking.

<img src="assets/talktrace-logo.png" alt="TalkTrace logo" width="160">

## Installation

Copy this page URL, paste it into the LLM / AI / Agent on your computer, and say:

```text
Hey, help me install this on my computer:
https://github.com/bilbillm/TalkTrace
```

If it asks how, send this too:

```text
Put the real working copy in my Documents directory and name it TalkTrace-workspace.
Do not make me fill real chat notes inside the public GitHub clone.
After installation, read START_HERE.md and AGENTS.md, then help me initialize my first chat object.
```

The agent can run:

```powershell
$repo = Join-Path $env:TEMP "TalkTrace"
if (Test-Path $repo) { Remove-Item -LiteralPath $repo -Recurse -Force }
git clone https://github.com/bilbillm/TalkTrace $repo
powershell -ExecutionPolicy Bypass -File "$repo\scripts\install-talktrace.ps1" `
  -Destination "$HOME\Documents\TalkTrace-workspace"
```

macOS / Linux:

```bash
repo="$(mktemp -d)/TalkTrace"
git clone https://github.com/bilbillm/TalkTrace "$repo"
bash "$repo/scripts/install-talktrace.sh" "$HOME/TalkTrace-workspace"
```

After installation, enter the workspace and ask the agent to read `START_HERE.md` and `AGENTS.md`.

If you often think, "I do not know how to chat," "I cannot tell what the other person wants," "replying feels exhausting," or "I want to sound more natural," this project is for you.

TalkTrace does not ask you to hand every sentence over to AI. It turns chatting into something you can observe, review, practice, and iterate. You provide chat context and your own first reaction; the assistant helps organize person-specific notes, read the current situation, draft a few replies that still sound like you, and update local files after you confirm what should be persisted.

## What It Helps With

- Train your chat skills instead of memorizing scripts.
- Get 2-3 directly sendable replies when you do not know what to say.
- Clarify your position in the other person's eyes: internet acquaintance, friend, flirtation, transactional relationship, coworker, long-term partner, and so on.
- Understand what kind of person you are in chat: active or passive, accommodating or distant, steady or over-invested.
- Keep every chat object separate, so you do not copy the style of one relationship into another.
- Review sent replies: what worked, what cooled the conversation, and what only looked "emotionally intelligent" in the moment.

## Who This Is For

- People who want to practice chatting with others but do not know where to start.
- People who feel bad about their current chat skills and want a gentle but practical support system.
- People who find conversation tiring and need to clarify relationship position and reply goals first.
- People who want to review their own communication patterns over time.
- People already using AI for replies, but who want the result to sound more like themselves instead of a generic template.

## Who This Is Not For

- People who want to manipulate, pressure, PUA, or control others.
- People who want AI to own all relationship judgment for them.
- People who want to force every conversation toward romance or flirtation.
- People who want to diagnose others, fix them into personality labels, or use gender, sexuality, or trauma as a universal explanation.

## Core Idea

TalkTrace uses a "global self layer + isolated person layer" structure.

`me/` records your general chat profile, shared wording habits, your own unconscious relational hypotheses, and cross-person cases. It answers: "How do I usually speak? How do I tend to react in relationships?"

`people/<alias>/` records the files for one specific chat object: your relationship position, the person's visible persona, their speculative unconscious profile, the way you speak to this person, and selected review cases. It answers: "In front of this person, how can I speak in a way that is still me and still fits this relationship?"

The project also borrows from Lacanian psychoanalysis to better handle the gap between "what the other person literally said" and "how they may want to be seen." Concepts such as desire, gaze, the Other, lack, signifier, symptom, and fantasy can help identify recurring relational dynamics in chat.

But psychoanalysis here is not a diagnostic tool. Every "unconscious profile" entry must be written as a hypothesis, with evidence, plain-language translation, reply strategy, and risk. It exists to support steadier and more natural replies, not to define anyone.

## Directory Layout

```text
.
├── AGENTS.md
├── README.md
├── README.en.md
├── assets/
│   └── talktrace-logo.png
├── scripts/
│   ├── install-talktrace.ps1
│   ├── install-talktrace.sh
│   ├── new-person.ps1
│   └── new-person.sh
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

## How To Use

1. Use the installation commands above to create a local private workspace, or create your own private repository from this template.
2. Keep your real working copy private or local-only.
3. Run `scripts/new-person.ps1 -Alias <alias>` to copy `people/_template/` to `people/<alias>/`. Use an alias, not a real name.
4. Give the assistant the new chat context, your first reaction, and the direction you want for the relationship.
5. Let the assistant read `me/` plus the relevant `people/<alias>/` files before drafting reply suggestions.
6. Choose or edit one reply. After you receive feedback, let the assistant update that person's `cases.md`, and update `profile.md`, `style.md`, or `unconscious.md` when needed.

## A Fictional Example

```text
Object: A
Relationship: ordinary friend, recently hoping to get a little closer
They said: I have been so tired lately. I do not want to do anything.
My feeling: I want to comfort them, but I am afraid of trying too hard.
```

The assistant reads:

- `me/style.md`: your usual sentence length, tone, emoji habits, and forbidden phrases.
- `people/A/profile.md`: the current relationship and boundaries.
- `people/A/persona.md`: how A visibly expresses themselves and tends to continue a conversation.
- `people/A/unconscious.md`: hypotheses about A's relational dynamics.
- `people/A/cases.md`: which previous replies worked or failed.

Then it gives a short suggestion:

```text
I read this more as wanting to be received than asking for a solution.

Avoid:
- Direct advice: "Just go exercise and you will feel better."
- Over-intensity: "I feel so bad for you."

Options:
1. Safe: "Sounds like you are tired enough that even dealing with things takes effort. Do not push yourself today."
2. Closer: "Then collapse for a while. I am here. Toss it to me if you want to talk; no pressure if you do not."
3. Short: "Lie down first. You do not have to force it today."
```

If you send option 2 and A continues opening up, the assistant can summarize the case into `people/A/cases.md`. If it was just an ordinary exchange, nothing needs to be saved.

## How AI Maintains The Files

Default rule: the assistant may help organize files, but important judgments need your confirmation.

- Clear facts can be recorded directly, such as when you met, region, relationship boundary, or a reply you already sent.
- Hypotheses must be marked as hypotheses, not conclusions.
- Important relationship judgments should be confirmed first, such as "they are trying to get closer," "this relationship has cooled down," or "a more distant tone is better from now on."
- `unconscious.md` only stores dynamic hypotheses that help reply strategy, not mystical explanations.
- Do not save full chat logs. Save selected original lines, your reply, the other person's feedback, and review conclusions.

## Important: Privacy And Safety

This public repository is only a template. In real use, keep your working copy in a private repository or a local directory.

Do not commit the following to a public repository:

- Real names, WeChat IDs, QQ IDs, phone numbers, email addresses, or addresses.
- Chat screenshots, full chat transcripts, or raw exports.
- Identifiable photos, voice messages, locations, bills, tickets, or transaction records.
- Highly sensitive relationship details without the other person's consent.

By default, `.gitignore` keeps only `people/_template/` and ignores real `people/<alias>/` directories. This is designed to prevent accidentally pushing concrete person files to a public repository.

If you use Git to track your real reviews, use a private repository or local commits only.

## License

MIT
