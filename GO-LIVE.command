#!/bin/bash
# Maven — one-click public deployment.
# Double-click this. Wait 60 seconds. Get a real public URL.
# Right-click → Open → Open the first time (macOS Gatekeeper).

set -e
cd "$(dirname "$0")"

# ── colors ──
B='\033[1m'; G='\033[1;32m'; Y='\033[1;33m'; R='\033[1;31m'; C='\033[1;36m'; N='\033[0m'

clear
printf "${C}\n"
cat <<'EOF'
  ╔════════════════════════════════════════════════════╗
  ║                                                    ║
  ║     ✦  Maven — going live                          ║
  ║         setting up your public chat URL…           ║
  ║                                                    ║
  ╚════════════════════════════════════════════════════╝
EOF
printf "${N}\n"

# ── 1. Node check ──
if ! command -v node >/dev/null 2>&1; then
  printf "${R}✗${N}  Node.js not installed.\n\n"
  printf "  Install it from ${C}https://nodejs.org${N} (LTS button), then double-click this file again.\n\n"
  read -n 1 -s -r -p "Press any key to close..."
  exit 1
fi
NODE_MAJOR=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_MAJOR" -lt 22 ]; then
  printf "${R}✗${N}  Node $NODE_MAJOR is too old. Need 22 or higher.\n\n"
  printf "  Update from ${C}https://nodejs.org${N}\n\n"
  read -n 1 -s -r -p "Press any key to close..."
  exit 1
fi
printf "${G}✓${N}  Node $(node -v)\n"

# ── 2. Dependencies ──
if [ ! -d "node_modules" ]; then
  printf "${Y}⟳${N}  Installing project dependencies (first run, ~30 sec)…\n"
  npm install --no-audit --no-fund --silent >/dev/null 2>&1 || npm install --no-audit --no-fund
  printf "${G}✓${N}  Dependencies installed\n"
else
  printf "${G}✓${N}  Dependencies ready\n"
fi

# ── 3/4. AI backend ──
HAS_KEY=0
if [ -f .env ] && grep -qE '^ANTHROPIC_API_KEY=sk-ant-' .env && ! grep -q 'paste-your-key-here' .env; then
  HAS_KEY=1
  printf "${G}✓${N}  Anthropic API key found in .env\n"
else
  printf "${Y}⚠${N}  No ANTHROPIC_API_KEY in .env — the AI will run on your personal Claude subscription.\n"
  printf "    That's OK for testing with friends, but before real public users,\n"
  printf "    create a key at ${C}https://console.anthropic.com${N} and put it in .env:\n"
  printf "    ${C}ANTHROPIC_API_KEY=sk-ant-…${N}\n\n"
  if ! command -v claude >/dev/null 2>&1; then
    printf "${Y}⟳${N}  Installing Claude Code globally (~30 sec)…\n"
    if ! npm install -g @anthropic-ai/claude-code 2>&1 | tail -2; then
      printf "${R}✗${N}  Couldn't install Claude Code. Try: ${C}sudo npm install -g @anthropic-ai/claude-code${N}\n"
      printf "    or add ANTHROPIC_API_KEY to .env instead.\n\n"
      read -n 1 -s -r -p "Press any key to close..."
      exit 1
    fi
  fi
  printf "${Y}⟳${N}  Checking Claude subscription login…\n"
  # macOS has no `timeout` — perl alarm keeps this from hanging
  AUTH_CHECK=$(perl -e 'alarm shift; exec @ARGV' 30 claude -p "reply with the word ok" --output-format text 2>&1 | head -5 || true)
  if [ -z "$AUTH_CHECK" ] || echo "$AUTH_CHECK" | grep -qiE "login|authenticate|unauthorized|please run|/login|invalid api key"; then
    printf "${Y}⚠${N}  Claude Code isn't logged in.\n"
    printf "  Press ENTER → Claude Code opens → type ${C}/login${N} → sign in → type ${C}/exit${N}.\n"
    read -p "" _
    claude || true
  else
    printf "${G}✓${N}  Claude subscription logged in\n"
  fi
fi

# ── 5. Cloudflared ──
CLOUDFLARED=""
if command -v cloudflared >/dev/null 2>&1; then
  CLOUDFLARED="cloudflared"
  printf "${G}✓${N}  Cloudflared ready ($(cloudflared --version 2>&1 | head -1))\n"
elif [ -x "node_modules/cloudflared/bin/cloudflared" ]; then
  CLOUDFLARED="$(pwd)/node_modules/cloudflared/bin/cloudflared"
  printf "${G}✓${N}  Cloudflared ready (bundled)\n"
else
  printf "${Y}⟳${N}  Installing cloudflared (~30 sec)…\n"
  if command -v brew >/dev/null 2>&1; then
    printf "    Using Homebrew…\n"
    if brew install cloudflared 2>&1 | tail -3 | grep -qiE "error|fail"; then
      printf "${Y}⚠${N}  Homebrew install hit a snag, trying npm fallback…\n"
    fi
    if command -v cloudflared >/dev/null 2>&1; then
      CLOUDFLARED="cloudflared"
    fi
  fi
  if [ -z "$CLOUDFLARED" ]; then
    # Fallback: npm package downloads the binary on first run
    printf "    Using npm cloudflared package…\n"
    npm install --no-audit --no-fund --silent cloudflared >/dev/null 2>&1 || true
    node -e "const c = require('cloudflared'); c.install(c.bin).then(() => process.exit(0)).catch(e => { console.error(e.message); process.exit(1); });" 2>&1 | head -5
    if [ -x "node_modules/cloudflared/bin/cloudflared" ]; then
      CLOUDFLARED="$(pwd)/node_modules/cloudflared/bin/cloudflared"
    fi
  fi
  if [ -z "$CLOUDFLARED" ] || ! [ -x "$CLOUDFLARED" ] && ! command -v "$CLOUDFLARED" >/dev/null 2>&1; then
    printf "${R}✗${N}  Couldn't install cloudflared.\n\n"
    printf "  ${B}Easiest fix:${N}\n"
    printf "  1. Install Homebrew from ${C}https://brew.sh${N} (one paste in Terminal)\n"
    printf "  2. Run: ${C}brew install cloudflared${N}\n"
    printf "  3. Double-click this file again.\n\n"
    printf "  ${B}Or skip cloudflared entirely:${N}\n"
    printf "  You can run Maven locally — open ${C}http://localhost:3000/index.html${N} in your browser.\n"
    printf "  The site will work for you, but won't be accessible to others.\n\n"
    read -n 1 -s -r -p "Press any key to close..."
    exit 1
  fi
  printf "${G}✓${N}  Cloudflared installed\n"
fi

mkdir -p data

# ── 8. Free up port 3000 if something's using it ──
EXISTING=$(lsof -nP -iTCP:3000 -sTCP:LISTEN 2>/dev/null | awk 'NR==2{print $2}')
if [ -n "$EXISTING" ]; then
  printf "${Y}⟳${N}  Killing previous server on port 3000 (PID $EXISTING)…\n"
  kill $EXISTING 2>/dev/null || true
  sleep 1
fi

# ── 9. Start server in background ──
printf "${Y}⟳${N}  Starting Maven server…\n"
ALLOWED_ORIGINS="*" CROSS_ORIGIN=false NODE_ENV=production \
  node --experimental-sqlite server.js > /tmp/maven-server.log 2>&1 &
SERVER_PID=$!
# Verify server is alive (give it up to 10 seconds)
for i in $(seq 1 10); do
  curl -s --max-time 2 http://localhost:3000/healthz >/dev/null 2>&1 && break
  sleep 1
done
if ! curl -s --max-time 3 http://localhost:3000/healthz >/dev/null 2>&1; then
  printf "${R}✗${N}  Server didn't start. Log:\n"
  cat /tmp/maven-server.log | tail -15
  echo ""
  read -n 1 -s -r -p "Press any key to close..."
  exit 1
fi
printf "${G}✓${N}  Server running on http://localhost:3000\n"

# ── 10. Start tunnel and capture URL ──
printf "${Y}⟳${N}  Opening public tunnel via Cloudflare (~10 sec)…\n"
$CLOUDFLARED tunnel --url http://localhost:3000 > /tmp/maven-tunnel.log 2>&1 &
TUNNEL_PID=$!

# Cleanup on exit
trap "echo ''; echo 'Shutting down…'; kill $SERVER_PID $TUNNEL_PID 2>/dev/null; exit" INT TERM EXIT

# Wait for tunnel URL to appear
TUNNEL_URL=""
for i in $(seq 1 30); do
  TUNNEL_URL=$(grep -oE "https://[a-z0-9-]+\.trycloudflare\.com" /tmp/maven-tunnel.log 2>/dev/null | head -1)
  if [ -n "$TUNNEL_URL" ]; then break; fi
  sleep 1
done

if [ -z "$TUNNEL_URL" ]; then
  printf "${R}✗${N}  Tunnel didn't start. Log:\n"
  cat /tmp/maven-tunnel.log | tail -15
  echo ""
  read -n 1 -s -r -p "Press any key to close..."
  kill $SERVER_PID 2>/dev/null
  exit 1
fi

# ── 11. Display the live URL ──
clear
printf "${G}\n"
cat <<'EOF'
  ╔════════════════════════════════════════════════════╗
  ║                                                    ║
  ║     ✦  MAVEN IS LIVE                               ║
  ║                                                    ║
  ╚════════════════════════════════════════════════════╝
EOF
printf "${N}\n"
printf "  ${B}Your public website is at:${N}\n\n"
printf "    ${C}${B}$TUNNEL_URL${N}\n\n"
printf "  ${B}First time?${N}\n"
printf "    1. Open the URL above and click ${C}Sign up${N} as a ${B}professional${N}\n"
printf "       (the first account created becomes the site owner)\n"
printf "    2. Create your community → you get a 6-character invite code\n"
printf "    3. Send people the URL + the invite code — they sign up as students\n\n"
printf "  ${Y}⚠  The URL changes every time you run this.${N} For a permanent address, see DEPLOY.md.\n\n"
printf "  ${Y}⚠  This window must stay open${N}\n"
printf "     If you close this Terminal or your Mac sleeps, the URL stops working.\n"
printf "     System Settings → Battery → set ${B}'Prevent sleep when on power'${N} to never.\n\n"
printf "  Press ${C}Ctrl+C${N} to stop. Watching for activity:\n"
printf "  ─────────────────────────────────────────────────────────\n\n"

# ── 12. Tail the server log so the user sees activity ──
tail -f /tmp/maven-server.log
