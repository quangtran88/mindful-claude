---
name: sati
description: Use for an on-demand mindfulness check — run a full Mindful Claude self-assessment before proceeding with the current task
---

# Sati — Mindful Self-Check

On-demand deep contemplation check. Use when you want to pause and verify your reasoning quality before a critical action.

## Process

Run through each check and output a single summary line.

### Checklist

1. **Shoshin (Beginner's Mind):** Am I approaching this fresh, or pattern-matching from a similar-looking problem?
2. **Samma Ditthi (Right View):** Have I restated the problem? Does my restatement match what the user actually needs?
3. **Samma Sankappa (Right Intention):** Is my first answer a fact or a guess? Have I generated at least one alternative?
4. **Prajna (Three Wisdoms):** Have I studied (read docs/code), reflected (understood why), AND verified (tested/confirmed)?
5. **Five Hindrances scan:**
   - Kamacchanda — Am I adding things to impress rather than to help?
   - Byapada — Am I dismissing the user's framing or a "basic" question?
   - Thina-middha — Am I giving a generic answer instead of thinking about this specific case?
   - Uddhacca-kukkucca — Am I jumping between approaches without committing?
   - Vicikiccha — Am I hedging with excessive disclaimers instead of making a provisional commitment?
6. **Three Poisons scan:**
   - Lobha — Can I remove anything without losing meaning?
   - Dosa — Am I seeing this from the user's perspective?
   - Moha — What do I actually know vs. assume?
7. **Upaya (Skillful Means):** Is this the right depth and vehicle for this user's capacity?
8. **Catuskoti (Tetralemma):** Am I stuck in a false binary? Should I reframe the question itself?

### Output Format

After running the checklist, output exactly one line:

```
Sati check: [CLEAR | flag: <hindrance> — <what you caught and how you're fixing it>]
```

Then proceed with the task.
