# Maven (Synapse)

A group chat where a professional teaches a community, and an AI that has read every message answers students in the professional's voice, grounded only in what was said in the room.

## Run it on your Mac (testing)

Double-click **`start.command`** (first time: right-click → Open → Open). It opens http://localhost:3000.

1. **Sign up as a professional.** The first account ever created becomes the site owner.
2. Create a community. Click 🔗 to copy an **invite link** and send it to people.
3. They open the link, sign up (already set to "student"), and join your room automatically.

## Put it on the internet

### Option A: from your Mac (free, quick, temporary)
1. Create an API key at https://console.anthropic.com → put it in a file called `.env` in this folder:
   ```
   ANTHROPIC_API_KEY=sk-ant-...
   OWNER_EMAILS=hagaydardik@gmail.com
   ```
   (copy `.env.example` to `.env` and edit it.)
2. Double-click **`GO-LIVE.command`**. It prints a public `https://….trycloudflare.com` link.
3. Keep the window open and the Mac awake. The link changes every time you run it.

### Option B: permanent hosting (recommended before real launch)
The folder includes a `Dockerfile` and `render.yaml`. Push the folder to GitHub, then on
https://render.com → New → Blueprint → choose the repo, paste your `ANTHROPIC_API_KEY`.
You get a permanent URL that doesn't depend on your Mac (about $7/month for the server plus disk).

## Why an API key?
Without a key, the AI runs on your personal Claude Pro/Max subscription through Claude Code.
That's fine for testing on your own computer, but Anthropic's terms don't allow a personal
subscription to power an app for other people. With a key you pay per use (typically a few cents
per question with Sonnet; more in very long chats), and it's the supported way.

## Settings (`.env`)
| Setting | What it does |
|---|---|
| `ANTHROPIC_API_KEY` | Your API key. Needed for public use. |
| `AI_MODE` | `auto` (default), `api`, `subscription`, or `mock` (fake replies for testing). |
| `ANTHROPIC_MODEL` | Default `claude-sonnet-4-5`. |
| `OWNER_EMAILS` | Who may change the key/model from inside the app. |
| `PORT` | Default 3000. |

## Files
| Path | What it is |
|---|---|
| `public/` | The website: `index.html` (landing), `login.html`, `chat.html`, `maven.css`, `config.js` |
| `server.js` | The server: accounts, rooms, messages, AI |
| `data/synapse.sqlite` | The database (created automatically; back it up) |
| `archive/` | Old versions that aren't used any more |

To start over from scratch: stop the server, move `data/synapse.sqlite` somewhere else, start again.
