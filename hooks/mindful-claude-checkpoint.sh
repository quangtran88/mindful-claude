#!/bin/bash
# Mindful Claude — Visible Checkpoint Hook
# Fires on PreToolUse for Bash and Agent
# Reads tool input from stdin, checks for high-stakes patterns
# Returns visible self-check prompt for matches, empty JSON otherwise
# Detects tool type from JSON field presence (no env var dependency)
# Requires: jq

# Fail loudly if jq is missing
if ! command -v jq &>/dev/null; then
  cat <<'EOF'
{"additionalContext":"<mindful-claude-checkpoint>\nWARNING: jq is not installed. The Mindful Claude checkpoint hook cannot parse tool input and is inactive. Install jq to enable pre-commit self-checks.\n</mindful-claude-checkpoint>"}
EOF
  exit 0
fi

INPUT=$(cat)

MATCHED=false

# Check for Bash tool — has "command" field
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)
if [ -n "$COMMAND" ]; then
  if echo "$COMMAND" | grep -qiE '(git[[:space:]]+commit|git[[:space:]]+push|gh[[:space:]]+pr[[:space:]]+create)'; then
    MATCHED=true
  fi
fi

# Check for Agent tool — has "description" field (only if not already matched)
if [ "$MATCHED" = false ]; then
  DESCRIPTION=$(echo "$INPUT" | jq -r '.tool_input.description // empty' 2>/dev/null)
  if [ -n "$DESCRIPTION" ]; then
    if echo "$DESCRIPTION" | grep -qiE '(review|complete|final|deliver)'; then
      MATCHED=true
    fi
  fi
fi

if [ "$MATCHED" = true ]; then
  cat <<'EOF'
{"additionalContext":"<mindful-claude-checkpoint>\nVISIBLE SELF-CHECK REQUIRED before this action. Output one line:\n\n\"Awareness check: [CLEAR | flag: <trap> — <what you caught and how you're fixing it>]\"\n\nRun through:\n- Scope creep: Did I add anything unrequested? Is this the minimum that solves the problem?\n- False confidence: Am I claiming something I haven't verified? Do I know or assume?\n- Showing off: Is this for the user or for me?\n- Going through motions: Did I actually think about THIS case or give a generic answer?\n- Balanced presence: Am I attached to this being right, or open to correction?\n- Four-corner analysis: Did I consider that the question itself might need reframing?\n\nOne line. Be honest. Then proceed.\n</mindful-claude-checkpoint>"}
EOF
else
  echo '{"continue":true}'
fi
