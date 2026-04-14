# Mindful Claude

A Claude Code plugin that improves reasoning quality through cognitive awareness — instruction-level guidance and runtime enforcement hooks that catch common AI failure modes.

## What It Does

Mindful Claude is a three-layer behavioral system:

| Layer | Mechanism | Effect |
|-------|-----------|--------|
| **Reasoning Framework** | `CLAUDE.md` loaded at session start | Governs how Claude thinks — six ground-truth principles, a pre-response checklist, anti-pattern detection, cognitive trap scanning |
| **Knowledge Base** | `docs/knowledge-base.md` | Reference material backing the framework — 20+ cognitive concepts with AI applications and self-check questions |
| **Enforcement Hooks** | `hooks/` shell scripts via PreToolUse | Runtime reminders that prevent principle drift during long sessions |

### Why cognitive awareness?

Default LLM reasoning has predictable failure patterns. This framework names each one precisely and provides testable antidotes:

- **Pattern-matching instead of fresh analysis** → Fresh Eyes detection
- **Confidence without verification** → False Confidence detection
- **Adding unrequested scope** → Scope Creep detection
- **Hedging that blocks useful answers** → Analysis Paralysis detection
- **Dismissing "basic" questions** → Dismissiveness detection

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
| `self-check` | On-demand deep awareness self-check |

## Token Budget

| Hook | Fires on | Tokens/fire | Fires/session |
|------|----------|-------------|---------------|
| Baseline | Edit, Write, Agent, Bash | ~150 | ~15-20 |
| Checkpoint | git commit/push, gh pr create, completion agents | ~200 | ~2-3 |
| **Total** | | | **~2,850/session** (~0.3% of 1M context) |

## Concepts Covered

Root-cause tracing, Provisional thinking, Ego-free reasoning, Context-dependence, Fresh Eyes, Surface vs. Deeper Need, Pre-Response Checklist (See Clearly, Check Assumptions, Self-Monitor, Say Less Mean More, Expand the Frame, Learn-Think-Verify), Response Qualities (Genuine Helpfulness, Empathy, Shared Success, Balanced Presence), Adaptive Communication, Three Anti-Patterns (Scope Creep, Defensiveness, False Confidence), Five Cognitive Traps (Showing Off, Dismissiveness, Going Through Motions, Scattered Focus, Analysis Paralysis), Four-Corner Analysis, Flow State, Natural Flow.

## License

MIT
