#!/bin/bash
# Synapse one-click launcher (macOS) — double-click this file to start the app.
# Right-click → Open → Open on first run (Gatekeeper).
# This version uses your Claude Pro/Max subscription via Claude Code. No API key.

set -e
cd "$(dirname "$0")"

clear
cat <<'EOF'

  ╭─────────────────────────────────────────────╮
  │                                             │
  │   ✦  Synapse                                │
  │      Powered by your Claude subscription    │
  │                                             │
  ╰─────────────────────────────────────────────╯

EOF

# ── 1. Node check ────────────────────────────────────
if ! command -v node >/dev/null 2>&1; then
  echo "  ✗  Node.js not found."
  echo ""
  echo "     Install it from https://nodejs.org (pick the LTS button)."
  echo "     Then double-click this file again."
  echo ""
  read -n 1 -s -r -p "Press any key to close..."
  exit 1
fi

NODE_MAJOR=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_MAJOR" -lt 22 ]; then
  echo "  ✗  Node $NODE_MAJOR is too old. Synapse needs Node 22 or higher."
  echo ""
  echo "     Update from https://nodejs.org and try again."
  echo ""
  read -n 1 -s -r -p "Press any key to close..."
  exit 1
fi
echo "  ✓  Node $(node -v) detected"

# ── 2. Dependencies ──────────────────────────────────
if [ ! -d "node_modules" ] || [ ! -f "node_modules/.package-lock.json" ]; then
  echo "  ⟳  Installing dependencies (first run, ~30 sec)…"
  npm install --no-audit --no-fund --silent >/dev/null 2>&1 || npm install --no-audit --no-fund
  echo "  ✓  Dependencies installed"
else
  echo "  ✓  Dependencies already installed"
fi

# ── 3/4. AI backend ─────────────────────────────────
# If an Anthropic API key is in .env, that's all we need. Otherwise fall back to
# your local Claude subscription via Claude Code (fine for testing on your own Mac).
HAS_KEY=0
if [ -f .env ] && grep -qE '^ANTHROPIC_API_KEY=sk-ant-' .env && ! grep -q 'paste-your-key-here' .env; then
  HAS_KEY=1
  echo "  ✓  Anthropic API key found in .env"
fi

if [ "$HAS_KEY" = "0" ]; then
  if ! command -v claude >/dev/null 2>&1; then
    echo "  ⟳  Installing Claude Code (one-time, ~30 sec)…"
    if ! npm install -g @anthropic-ai/claude-code 2>&1 | tail -3; then
      echo ""
      echo "  ⚠  Couldn't install Claude Code globally."
      echo "     Either run:  sudo npm install -g @anthropic-ai/claude-code"
      echo "     or put ANTHROPIC_API_KEY=sk-ant-… in a .env file in this folder."
      echo ""
      read -n 1 -s -r -p "Press any key to close..."
      exit 1
    fi
    echo "  ✓  Claude Code installed"
  else
    echo "  ✓  Claude Code already installed ($(claude --version 2>&1 | head -1))"
  fi

  echo ""
  echo "  ⟳  Checking your Claude subscription login…"
  # macOS has no `timeout` command — use perl's alarm so this can never hang
  AUTH_CHECK=$(perl -e 'alarm shift; exec @ARGV' 30 claude -p "reply with the word ok" --output-format text 2>&1 | head -5 || true)
  if [ -z "$AUTH_CHECK" ] || echo "$AUTH_CHECK" | grep -qiE "login|authenticate|unauthorized|please run|/login|invalid api key"; then
    echo ""
    echo "  ⚠  Claude Code isn't logged in yet."
    echo "     Press ENTER — Claude Code opens. Type /login, sign in in the browser,"
    echo "     then type /exit to come back here."
    echo ""
    read -p "" _DUMMY
    claude || true
    echo ""
    echo "  ✓  Continuing…"
  else
    echo "  ✓  Claude subscription is logged in"
  fi
fi

# ── 5. Already running? ──────────────────────────────
PORT="${PORT:-3000}"
if lsof -nP -iTCP:$PORT -sTCP:LISTEN >/dev/null 2>&1; then
  echo "  ✓  Server is already running on port $PORT"
  echo ""
  echo "  → Opening http://localhost:$PORT/index.html in your browser…"
  open "http://localhost:$PORT/index.html"
  echo ""
  read -n 1 -s -r -p "Press any key to close this window..."
  exit 0
fi

# ── 6. Start server ──────────────────────────────────
echo ""
echo "  ⟳  Starting Synapse server…"
echo ""
echo "  ╭─────────────────────────────────────────────╮"
echo "  │                                             │"
echo "  │   Server running at:                        │"
echo "  │     http://localhost:$PORT                    │"
echo "  │                                             │"
echo "  │   Sign up → create a room → share code.     │"
echo "  │                                             │"
echo "  │                                             │"
echo "  │   Close this window to stop the server.     │"
echo "  │                                             │"
echo "  ╰─────────────────────────────────────────────╯"
echo ""

# open browser after a short delay so the server is up
(sleep 2 && open "http://localhost:$PORT/index.html") &

exec node --experimental-sqlite server.js
