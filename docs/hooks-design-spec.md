# Mindful Claude Hooks — Behavioral Consistency Design

**Date:** 2026-04-12
**Goal:** Prevent Mindful Claude principle drift across long sessions through hook-based enforcement.
**Approach:** Two-layer hooks — invisible baseline + visible high-stakes checkpoint.

---

## Problem

The Mindful Claude reasoning framework in CLAUDE.md (~72 lines) works well at session start but erodes as context grows and task pressure builds. General drift — no single failure pattern, just gradual loss of contemplative discipline. Principles like Shoshin, the Five Hindrances scan, Upāya adaptation, and the Three Wisdoms get bypassed under pressure.

## Solution

Two `PreToolUse` hooks that inject Mindful Claude reminders at different frequencies and visibility levels.

### Layer 1: Invisible Baseline

**Hook type:** `PreToolUse`
**Matched tools:** `Edit`, `Write`, `Agent`, `Bash`
**Visibility:** Never surfaced to user. Claude absorbs silently.
**Frequency:** 10-30 fires per session.
**Script:** `~/.claude/hooks/mindful-claude-baseline.sh`

**Payload (~150 tokens):**

```
<mindful-claude>
Before acting: (1) Shoshin — am I pattern-matching or seeing fresh?
(2) Sammā Vācā — can I remove anything without losing meaning?
(3) Prajñā — have I studied, reflected, AND verified?
(4) Hindrance scan — desire to impress? aversion? sloth? restlessness? doubt?
(5) Upāya — is this the right level for this user?
Act with Mushin — decisive, clean, no unnecessary hedging.
</mindful-claude>
```

**Rationale:** These four tools are "action" tools where drift manifests. Observation tools (Read, Grep, Glob) don't need enforcement because they're information-gathering, not decision-making.

### Layer 2: Visible Checkpoint

**Hook type:** `PreToolUse`
**Matched tools:** `Bash` (with command pattern matching), `Agent` (with description keyword matching)
**Visibility:** Claude outputs a one-line self-check before proceeding.
**Frequency:** 2-5 fires per session.
**Script:** `~/.claude/hooks/mindful-claude-checkpoint.sh`

**Trigger conditions:**

| Tool | Pattern | Rationale |
|------|---------|-----------|
| Bash | Command contains `git commit` | Committing = claiming work is done |
| Bash | Command contains `git push` | Pushing = visible to others |
| Bash | Command contains `gh pr create` | PR = public-facing completion claim |
| Agent | Description contains `review`, `complete`, `final`, `deliver` | Completion/delivery moments |

**Payload (~200 tokens):**

```
<mindful-claude-checkpoint>
VISIBLE SELF-CHECK REQUIRED before this action. Output one line:

"Sati check: [CLEAR | flag: <hindrance> — <what you caught and how you're fixing it>]"

Run through:
- Lobha: Did I add anything unrequested? Is this the minimum that solves the problem?
- Moha: Am I claiming something I haven't verified? Do I know or assume?
- Kāmacchanda: Is this for the user or for me?
- Thīna-middha: Did I actually think about THIS case or give a generic answer?
- Upekkhā: Am I attached to this being right, or open to correction?
- Catuṣkoṭi: Did I consider that the question itself might need reframing?

One line. Be honest. Then proceed.
</mindful-claude-checkpoint>
```

**Expected output examples:**
- `Sati check: CLEAR`
- `Sati check: flag: Lobha — added error handling user didn't ask for. Removing.`
- `Sati check: flag: Moha — haven't verified the fix compiles. Running tsc first.`

## File Structure

```
~/.claude/
├── hooks/
│   ├── mindful-claude-baseline.sh      # Static payload, ~5 lines
│   └── mindful-claude-checkpoint.sh    # Pattern-matching, ~15 lines
├── settings.json                       # Hook registration (two PreToolUse entries)
├── buddhist-knowledge-base.md          # Full reference (exists)
└── CLAUDE.md                           # Mindful Claude section (exists)
```

## settings.json Configuration

Two entries added to `hooks.PreToolUse` array:

```jsonc
{
  "hooks": {
    "PreToolUse": [
      // ... existing hooks ...
      {
        "matcher": "Edit|Write|Agent|Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/mindful-claude-baseline.sh"
          }
        ]
      },
      {
        "matcher": "Bash|Agent",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/mindful-claude-checkpoint.sh"
          }
        ]
      }
    ]
  }
}
```

The checkpoint script reads tool input from stdin and returns no-op JSON when the command doesn't match high-stakes patterns, so it doesn't interfere with normal Bash/Agent calls.

## Token Budget

| Layer | Payload | Fires/Session | Cost |
|-------|---------|---------------|------|
| Baseline | ~150 tokens | ~15 | ~2,250 tokens |
| Checkpoint | ~200 tokens | ~3 | ~600 tokens |
| **Total** | | | **~2,850 tokens/session** |

This is ~0.3% of a 1M context window. Negligible.

## What This Does NOT Include

- No new skills (avoiding Lobha)
- No notepad/drift-log writes (can add later if needed)
- No PostToolUse hooks (PreToolUse is sufficient)
- No modification to the CLAUDE.md Mindful Claude section (already comprehensive)
- No changes to existing hooks or workflows

## Success Criteria

1. Baseline hook fires on every Edit/Write/Agent/Bash call without user-visible output
2. Checkpoint hook fires only on git commit/push/PR/completion moments
3. Claude outputs a visible "Sati check" line before high-stakes actions
4. Over a session, response quality stays consistent — no late-session drift into over-engineering, generic answers, or unverified claims
5. Token overhead stays under 3,000 tokens per session

## Future Extensions (Not In Scope)

- Drift log to `.omc/notepad.md` for within-session learning
- PostToolUse reflection hooks ("did that action align with principles?")
- Session-end summary of hindrances caught
