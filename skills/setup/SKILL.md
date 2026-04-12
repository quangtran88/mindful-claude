---
name: setup
description: Use when first installing the Mindful Claude plugin — registers enforcement hooks in Claude Code settings.json
---

# Mindful Claude Setup

Registers the Mindful Claude PreToolUse hooks in your Claude Code settings.

## Process

1. **Locate the plugin's hooks directory.** The hooks are bundled with this plugin at `hooks/mindful-claude-baseline.sh` and `hooks/mindful-claude-checkpoint.sh`.

2. **Copy hooks to `~/.claude/hooks/`.** Find this plugin's installation directory (look for the directory containing this skill — it will be under `~/.claude/plugins/` or wherever Claude Code installs marketplace plugins), then copy:

```bash
mkdir -p ~/.claude/hooks
# Replace PLUGIN_DIR with the actual path to this plugin's root directory
cp PLUGIN_DIR/hooks/mindful-claude-baseline.sh ~/.claude/hooks/
cp PLUGIN_DIR/hooks/mindful-claude-checkpoint.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/mindful-claude-baseline.sh
chmod +x ~/.claude/hooks/mindful-claude-checkpoint.sh
```

3. **Register hooks in `~/.claude/settings.json`.** Add these two entries to the `hooks.PreToolUse` array (create the key if it doesn't exist):

```json
{
  "hooks": {
    "PreToolUse": [
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

4. **Verify hooks work:**

```bash
~/.claude/hooks/mindful-claude-baseline.sh | jq .
echo '{"tool_input":{"command":"git commit -m test"}}' | ~/.claude/hooks/mindful-claude-checkpoint.sh | jq .
echo '{"tool_input":{"command":"ls"}}' | ~/.claude/hooks/mindful-claude-checkpoint.sh | jq .
```

Expected: baseline always returns `additionalContext`, checkpoint returns it for git commit but `{"continue":true}` for ls.

5. **Confirm** to the user that setup is complete. The reasoning framework in CLAUDE.md loads automatically. The hooks provide runtime enforcement.
