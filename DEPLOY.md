# Maven — Zero-Cost Deployment Guide

How to get Maven live on the internet, working for real users, for **$0** + your existing Claude Pro/Max subscription.

## The architecture

```
  Real users  →  https://maven-il.netlify.app  (frontend, Netlify)
                            ↓
                      fetches API at
                            ↓
            https://abc-xyz.trycloudflare.com  (tunnel)
                            ↓
                  http://localhost:3000  (your Mac)
                            ↓
                        SQLite + Claude Code
                            ↓
                  Your Claude Pro/Max subscription
```

**Three pieces, all free:**

1. **Netlify** hosts the static frontend (`index.html`, `login.html`, `chat.html`, `maven.css`, `config.js`)
2. **Cloudflare Tunnel** gives the world a URL that points at your Mac
3. **Your Mac** runs the Node.js server (`server.js`), stores data in SQLite, talks to Claude via Claude Code (uses your existing subscription)

**Limitations of this setup** — be honest with yourself:

- ✅ Free
- ✅ Works for 5–20 users
- ✅ Real public URL
- ⚠️ Your Mac must be on for users to use it (sleep = downtime)
- ⚠️ Tunnel URL changes if you restart `cloudflared` (use a Cloudflare account + named tunnel for stable URLs)
- ⚠️ Data lives on your Mac. Back it up.

When you hit ~10 paying creators or get Anthropic credits, migrate to a real cloud host. Until then, this is enough.

---

## Step 0 — Prerequisites (one-time)

- macOS with Node.js 22+ installed (`node --version` to check)
- Your existing Claude Pro or Max subscription
- A free Cloudflare account (to get a stable tunnel URL) — optional but recommended
- A free Netlify account
- This project folder on your Mac

---

## Step 1 — Make sure the local setup works

In Terminal:

```bash
cd "/Users/hagaydardik/Documents/Claude/Projects/my master project- ai that focuses on the inteligence recieved from proffessionals speaking to theire ai"
npm install
```

Then double-click `start.command`. The launcher:
1. Installs Claude Code if missing
2. Prompts you to log in to Claude (browser tab opens, click Allow)
3. Starts the server

Visit http://localhost:3000/index.html in your browser. The site should load. Click "Sign up", create an account, create a room, send a message.

**If any of this fails**, fix it before moving on. The web deployment can't work if local doesn't.

---

## Step 2 — Install Cloudflare Tunnel

In Terminal:

```bash
brew install cloudflared
```

If you don't have Homebrew, install from https://brew.sh first.

---

## Step 3 — Start a quick tunnel (fastest path)

In a **new Terminal window** (keep the server running in the first one):

```bash
cloudflared tunnel --url http://localhost:3000
```

After ~10 seconds, you'll see:

```
+--------------------------------------------------------------------------------------------+
| Your quick Tunnel has been created! Visit it at:                                           |
| https://abc-defg-hijk-lmnop.trycloudflare.com                                              |
+--------------------------------------------------------------------------------------------+
```

**Copy that URL.** That's your public backend URL.

**Trade-off:** quick tunnels are temporary. URL changes every time `cloudflared` restarts. For a permanent URL, use a Cloudflare account + named tunnel (see Step 7).

---

## Step 4 — Update `config.js` with your tunnel URL

Open `config.js` in your editor. Find this line:

```js
const PRODUCTION_API = "https://CHANGE-ME.trycloudflare.com";
```

Replace `CHANGE-ME.trycloudflare.com` with your actual tunnel URL from Step 3.

Save the file.

---

## Step 5 — Tell the server to trust your future Netlify URL

Open `.env` in the project root (create it from `.env.example` if it doesn't exist):

```bash
cp .env.example .env
```

Add these lines to `.env`:

```bash
ALLOWED_ORIGINS=*
CROSS_ORIGIN=true
```

For now use `*` (allow any origin). Once you have your Netlify URL, change it to:

```bash
ALLOWED_ORIGINS=https://maven-il.netlify.app,http://localhost:3000
CROSS_ORIGIN=true
```

(Replace `maven-il.netlify.app` with your actual Netlify subdomain.)

**Restart the server** (Ctrl+C in the Terminal where `npm start` is running, then `npm start` again, or close and re-open `start.command`).

---

## Step 6 — Deploy the frontend to Netlify

The easiest way:

1. Go to https://app.netlify.com/drop
2. Drag and drop these files (not the whole folder — just these specific files):
   - `index.html`
   - `login.html`
   - `chat.html`
   - `maven.css`
   - `config.js`
   - `netlify.toml`
3. Netlify uploads, deploys, gives you a URL like `https://lovely-name-12345.netlify.app`

**Test it:** open the Netlify URL. The landing page loads. Click "Sign up". The login screen loads. Try to sign up — it should call your tunnel URL, which calls your Mac, which writes to SQLite, which sets a cookie, and you land in `chat.html`.

**If you see "השרת לא נגיש" (server unreachable)** at the bottom of `chat.html`:
- Check that `cloudflared` is still running
- Check that `npm start` is still running
- Check that `config.js` has your correct tunnel URL
- Check the browser console for the actual error

---

## Step 7 — (Optional but recommended) Stable Cloudflare URL

Quick tunnels change URL every restart. For a stable URL like `maven-api.yourcompany.com`, you need a Cloudflare account + named tunnel.

1. Sign up at https://cloudflare.com (free)
2. Add a domain you own (or buy one — `.dev` is ~$10/yr)
3. Run:
   ```bash
   cloudflared tunnel login
   cloudflared tunnel create maven-api
   ```
4. Configure DNS to point `maven-api.yourdomain.com` at the tunnel
5. Run:
   ```bash
   cloudflared tunnel run --url http://localhost:3000 maven-api
   ```

Now your tunnel URL is permanent. Update `config.js` accordingly.

**Full guide:** https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel/

---

## Step 8 — Invite your first 5 creators

Once everything's running:

1. Open your Netlify URL
2. Sign up as a **professional**
3. Create your first community — give it a name, get an invite code (6 characters)
4. Share the invite code with 5 people

They:
1. Visit your Netlify URL
2. Sign up as a **student** 
3. After signup, paste the invite code in the modal
4. They're in your room

Send a message. Click **✨ שאל AI** mode, ask a question. AI replies via your Claude Pro account (free for you, included in your $20/month).

---

## Step 9 — Keep it running

For users to actually use Maven, three things must be running:

1. **Mac is on** (not asleep) — Set System Preferences → Battery → Power Adapter → "Prevent your Mac from sleeping..." to never
2. **Server is running** — `npm start` or `start.command`
3. **Tunnel is running** — `cloudflared tunnel --url http://localhost:3000`

If you close Terminal, both stop. To keep them running in the background:

```bash
# Start server in background
nohup npm start > server.log 2>&1 &

# Start tunnel in background
nohup cloudflared tunnel --url http://localhost:3000 > tunnel.log 2>&1 &
```

To check they're alive:
```bash
ps aux | grep -E "node|cloudflared"
```

To stop:
```bash
pkill -f "node server.js"
pkill -f "cloudflared"
```

For a more robust setup, use `pm2` or write a launchd plist. (Ask for help if you want this.)

---

## Step 10 — Monitor it

Once a day, check:

- **`data/synapse.sqlite`** exists and is growing → users are real
- **Netlify Analytics** (in your Netlify dashboard) → see how many people visit your site
- **Server logs** (`server.log` if you ran with nohup) → see if anything is erroring

Once you have 3+ active creators each with a real cohort using it daily, **apply to Anthropic for Startups** with this real traction. See `ANTHROPIC-APPLICATION.md` for the application playbook.

---

## Troubleshooting

**"Server unreachable" banner shows up in chat.html**
- Server isn't running, or tunnel isn't running, or `config.js` has the wrong URL.
- Test the tunnel URL directly in your browser — visit `https://your-tunnel.trycloudflare.com/api/info`. You should see JSON.
- If JSON shows up: tunnel is fine, problem is in `config.js`.
- If you get an error: tunnel or server is down.

**Login works, chat.html loads, but it shows "אין הודעות עדיין" forever**
- You're logged in but in no rooms. Click the "+" icon at the top of chat or use the "Join room" panel to create or join one.

**AI replies fail with "Claude Code isn't authenticated"**
- Open Terminal, run `claude /login`, log in via browser, then refresh the page.

**Cookies don't persist between page loads**
- Your tunnel URL might not be HTTPS, OR your `.env` doesn't have `CROSS_ORIGIN=true`. Both are required for cross-origin cookies.

**I want to start over from scratch**
- Stop server, delete `data/synapse.sqlite`, restart server. Database is recreated empty.

**Tunnel URL keeps changing — my creators have to update their bookmarks**
- Switch from quick tunnel to named tunnel (Step 7). Costs ~$10/yr for a domain.

---

## What to do once you have credits from Anthropic

If you get accepted to Anthropic for Startups and get credits, you'll want to migrate to a more robust setup:

1. **Move database** to Supabase free tier (Postgres). Code change: ~half a day of work.
2. **Move backend** to Render or Fly.io with a real always-on server. Stops requiring your Mac.
3. **Switch from Claude Code subscription auth** to API key auth using the credits. Code change: a few lines.
4. **Set up real domain** for both frontend (`maven.app`) and backend (`api.maven.app`).

Until then, the setup above is enough. Don't over-engineer until users force you to.

---

## The minimum daily checklist

While you're growing:

- [ ] Server running on Mac (check `lsof -i :3000`)
- [ ] Tunnel running (check `ps aux | grep cloudflared`)
- [ ] Mac awake (sleep mode disabled)
- [ ] At least one community member messaged today (check the database)

If you keep these four things true for 4 weeks straight, you'll have something to show Anthropic.
