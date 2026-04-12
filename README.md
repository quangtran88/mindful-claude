# Mindful Claude

A Claude Code plugin that maps Buddhist cognitive concepts to AI failure modes, improving reasoning quality through instruction-level guidance and runtime enforcement hooks.

## What It Does

Mindful Claude is a three-layer behavioral system:

| Layer | Mechanism | Effect |
|-------|-----------|--------|
| **Reasoning Framework** | `CLAUDE.md` loaded at session start | Governs how Claude thinks — six ground-truth principles, a before-responding checklist, Three Poisons detection, Five Hindrances scan |
| **Knowledge Base** | `docs/knowledge-base.md` | Verified reference material backing the framework — 20+ Buddhist concepts with AI applications and self-check questions |
| **Enforcement Hooks** | `hooks/` shell scripts via PreToolUse | Runtime reminders that prevent principle drift during long sessions |

### Why Buddhist concepts?

Default LLM reasoning has predictable failure patterns. Buddhist cognitive frameworks name each one precisely and provide testable antidotes:

- **Pattern-matching instead of fresh analysis** → Shoshin (Beginner's Mind)
- **Confidence without verification** → Moha (Delusion) detection
- **Adding unrequested scope** → Lobha (Greed) detection
- **Hedging that blocks useful answers** → Vicikiccha (Doubt) detection
- **Dismissing "basic" questions** → Byapada (Aversion) detection

## Installation

### As a Claude Code marketplace plugin

```bash
claude plugin add --marketplace github:quangtran88/mindful-claude
```

The `CLAUDE.md` reasoning framework loads automatically on every session.

### Hook Setup (Optional)

The hooks provide runtime enforcement — silent reminders on every tool call, plus visible self-checks before high-stakes actions (git commit, push, PR creation).

After installing the plugin, run the setup skill:

```
/mindful-claude:setup
```

Or manually:

1. Copy hooks to `~/.claude/hooks/`:
```bash
cp <plugin-path>/hooks/mindful-claude-*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/mindful-claude-*.sh
```

2. Add to `~/.claude/settings.json`:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write|Agent|Bash",
        "hooks": [{ "type": "command", "command": "~/.claude/hooks/mindful-claude-baseline.sh" }]
      },
      {
        "matcher": "Bash|Agent",
        "hooks": [{ "type": "command", "command": "~/.claude/hooks/mindful-claude-checkpoint.sh" }]
      }
    ]
  }
}
```

**Requires:** `jq` (for the checkpoint hook's JSON parsing)

## Skills

| Skill | Description |
|-------|-------------|
| `setup` | Registers enforcement hooks in Claude Code settings |
| `sati` | On-demand deep mindfulness self-check |

## Token Budget

| Hook | Fires on | Tokens/fire | Fires/session |
|------|----------|-------------|---------------|
| Baseline | Edit, Write, Agent, Bash | ~150 | ~15-20 |
| Checkpoint | git commit/push, gh pr create, completion agents | ~200 | ~2-3 |
| **Total** | | | **~2,850/session** (~0.3% of 1M context) |

## Concepts Covered

Dependent Origination, Impermanence, Non-self, Emptiness, Beginner's Mind, Two Truths, Noble Eightfold Path (Right View, Right Intention, Right Mindfulness, Right Speech), Four Immeasurables (Metta, Karuna, Mudita, Upekkha), Skillful Means, Three Wisdoms, Three Poisons, Five Hindrances, Tetralemma, No-Mind, Effortless Action, Indra's Net, Bodhicitta, Ox-Herding Pictures.

## License

MIT
