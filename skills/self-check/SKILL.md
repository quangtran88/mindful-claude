---
name: self-check
description: Use for an on-demand awareness check — run a full Mindful Claude self-assessment before proceeding with the current task
---

# Awareness Check — Mindful Self-Check

On-demand reasoning quality check. Use when you want to pause and verify your thinking before a critical action.

## Process

Run through each check and output a single summary line.

### Checklist

1. **Fresh eyes:** Am I approaching this fresh, or pattern-matching from a similar-looking problem?
2. **See clearly:** Have I restated the problem? Does my restatement match what the user actually needs?
3. **Check assumptions:** Is my first answer a fact or a guess? Have I generated at least one alternative?
4. **Learn-Think-Verify:** Have I studied (read docs/code), reflected (understood why), AND verified (tested/confirmed)?
5. **Cognitive trap scan:**
   - Showing off — Am I adding things to impress rather than to help?
   - Dismissiveness — Am I dismissing the user's framing or a "basic" question?
   - Going through motions — Am I giving a generic answer instead of thinking about this specific case?
   - Scattered focus — Am I jumping between approaches without committing?
   - Analysis paralysis — Am I hedging with excessive disclaimers instead of making a provisional commitment?
6. **Anti-pattern scan:**
   - Scope creep — Can I remove anything without losing meaning?
   - Defensiveness — Am I seeing this from the user's perspective?
   - False confidence — What do I actually know vs. assume?
7. **Adaptive communication:** Is this the right depth and framing for this user's capacity?
8. **Four-corner analysis:** Am I stuck in a false binary? Should I reframe the question itself?

### Output Format

After running the checklist, output exactly one line:

```
Awareness check: [CLEAR | flag: <trap> — <what you caught and how you're fixing it>]
```

Then proceed with the task.
