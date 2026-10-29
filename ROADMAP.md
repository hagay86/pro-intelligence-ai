# Synapse — Vision & Roadmap

## The vision in one paragraph

Every cohort-based class on Earth should run on Synapse. Not because it has the most features. Because the **core thing it does** — letting one professional teach a group while an AI silently absorbs every word and helps students 24/7 — is so essential that no other tool feels acceptable once you've used it. Slack didn't win on features. Notion didn't win on features. They won because the core experience was so good that switching back felt like a downgrade. That's the goal here.

## What the product IS (and isn't)

**It is:**
- A group chat scoped to one cohort
- Led by one clear professional / mentor / teacher
- With an AI that listens to every message and remembers everything
- Where students can ask the AI questions any time, in the group or 1:1
- And the AI's answers are **grounded only in what's been said in that room** — never generic, always cited

**It isn't:**
- A learning management system (no assignments / gradebook / attendance modules)
- A school administration tool (no admin dashboards, no compliance suites, no district reporting)
- An LMS replacement
- A bot that pretends to be the teacher

These things are bloat that hides the magic. The magic is one chat room and one AI that knows your professor.

## Why this can be the default for everyone teaching

When the core product is this strong, three forces compound:

**1. The professional invites their students.** A solo teacher with 10 students brings 10 users in one room. They tell their network. Their students tell their friends. Adoption is cohort-shaped — one room invites the next.

**2. The AI gets better with use.** The more the professional teaches in Synapse, the more knowledge the AI has to answer from. The product gets dramatically more valuable the longer you use it. That's the strongest possible retention loop.

**3. It's easy to start, easy to switch to.** A teacher can spin up a room in 30 seconds and invite a cohort with a 6-character code. Compared to the LMS giants (Canvas, Moodle, Blackboard) which take weeks to set up and need an IT department, Synapse takes a minute. The activation energy is near zero.

A focused product, with one clear teacher per room, scales by word-of-mouth from one cohort to the next — not by selling enterprise contracts to school boards.

## Who uses it (today and as it spreads)

The product is identical for everyone. The audience is who *adopts* it:

**Wedge 1 — Independent cohort instructors.** Course creators, bootcamps, mentors, professional educators. Already running cohorts on Discord + Notion + Google Drive + Zoom + email. They feel the pain of stitching those together. They make their own buying decisions. They're loud advocates when something is good.

**Wedge 2 — University seminars + grad-school cohorts.** Small, intimate classes (5–25 students) led by one professor. The Department of Computer Science doesn't need to buy it — the professor of CS 401 does.

**Wedge 3 — High school AP teachers and elective leaders.** Same pattern: one teacher, one cohort, low admin overhead. Tech-forward teachers adopt first.

**Wedge 4 — Tutoring & supplementary education.** SAT prep tutors, music teachers, language coaches, writing coaches. Tiny cohorts, premium pricing, deep teacher–student relationship.

In every wedge: the unit is **one teacher with their cohort**. Same product, different verticals.

## Phased build

### Phase 0 — Today (this repo)
- ✅ Single-room group chat with AI listener
- ✅ Real signup / login / rooms / invite codes
- ✅ "Ask AI" in group + AI's auto-organized notes
- ✅ Subscription auth via Claude Code (no separate API key)
- ✅ Local Node + SQLite

### Phase 1 — Make the core product undeniable (1–2 months)
Goal: a teacher with 10 students should feel **this is the best place to run my cohort**.
- Deploy to the web (real URL, not localhost) — Vercel / Render
- Real persistent multi-tenant storage (Postgres)
- Mobile-responsive (works perfectly on phones — students live on phones)
- Push / email notifications when teacher replies or AI answers
- File uploads in chat (PDFs, images)
- Voice notes from the teacher → auto-transcribed into the room (huge teacher-time saver)
- "Topics" feature so the AI organizes answers by theme automatically

### Phase 2 — Private AI sessions (2–3 months)
Goal: students can also have **private** AI conversations grounded in the cohort.
- 1:1 AI chats per student, still grounded in the room
- Teacher dashboard showing what students are asking the AI (without revealing identity if students prefer)
- "Practice" mode — AI generates exercises from real lessons

### Phase 3 — Multi-cohort for the same teacher (3–4 months)
Goal: a teacher running 3 cohorts can manage them all in Synapse.
- Multiple rooms per professional
- AI knows which cohort it's answering for (no cross-contamination)
- Shared knowledge base across cohorts if the teacher wants

### Phase 4 — Cohort discovery + monetization (4–6 months)
Goal: turn the platform into a market.
- Teacher profiles, public if they want
- Students can find and pay to join cohorts (Stripe)
- Synapse takes a small cut on transactions
- Built-in scheduling for office hours

### Phase 5 — Polish, scale, languages (ongoing)
- Native iOS + Android apps
- 30+ languages
- Better video / audio integration for live sessions (built-in, not Zoom)
- Open API for power users

**That's the whole roadmap.** No admin dashboards. No university bureaucracy modules. No accreditation tools. The product stays focused — what scales is the number of cohorts using it.

## How it becomes "the new students' AI everywhere"

Not by being everything to everyone. By being **the best possible version of one specific thing**: the group chat for a cohort with an AI that remembers.

When that's nailed:
- Every independent teacher in the world will want to use it because it's the lightest, smartest place to run their cohort
- Every university seminar professor will want to use it because their TAs become AI-augmented
- Every tutoring service will want to use it because retention goes through the roof
- Every K-12 elective teacher will use it because students actually engage with the AI

The platform-ness comes from **volume of cohorts**, not from selling to school districts. Bottom-up, not top-down. One professional at a time, multiplying.

## What we measure

Success is not "users" or "MAUs". Success is:

- **Time-to-first-AI-answer** — from teacher signup, how fast does a student get their first grounded answer? Goal: < 24 hours.
- **Daily room activity** — among rooms with 5+ students, what % have a message every weekday? Goal: 80%+.
- **AI answer trust** — when AI replies, what % of students reply "thanks" or follow up? Goal: 60%+.
- **Cohort completion rate** — what % of students finish the cohort vs. drop off? Goal: beat the cohort-course industry average of ~25%.
- **Teacher net invites** — how many new teachers does an existing teacher refer in 90 days? Goal: 0.5+.

When those numbers are strong, growth takes care of itself.

## Architecture for Phase 1+ (the real production build)

- **Frontend:** Next.js, mobile-first
- **Realtime chat:** WebSockets via a small Elixir/Phoenix or Node service
- **Storage:** Postgres with row-level security keyed off `room_id`
- **AI:** Anthropic API (model swappable). Every AI call gets the room's full transcript as system context.
- **Auth:** Magic-link email login (no passwords for v1 — too much friction)
- **Hosting:** Vercel (frontend) + Render/Fly.io (realtime + DB)
- **Mobile:** Phase 5 — React Native or native Swift/Kotlin

## What this repo holds today

```
.
├── ROADMAP.md              ← this file
├── README.md               ← setup guide
├── index.html              ← landing + working demo (this is the website)
├── Synapse.html            ← standalone demo (single-file, no install)
├── synapse.css             ← shared styles
├── server.js               ← Phase 0 backend (Node + SQLite)
├── start.command           ← double-click launcher
├── seed-hagay.js           ← seed your first account
├── public/                 ← served by server.js
└── data/                   ← runtime (gitignored)
```

The HTML demo at `index.html` is the marketing surface. `Synapse.html` is the standalone fully-working chat (no install if you serve it via the local server). The Node server is the working Phase 0 backend.

## Next step

Pick a wedge and ship Phase 1 for real:

1. **Stand up the production deployment** (Vercel + Postgres + magic-link auth) — 1 week
2. **Onboard the first 10 teachers** from your own network or LinkedIn — paid or free, doesn't matter, get real usage — 2 weeks
3. **Iterate weekly** based on what those 10 teachers tell you — ongoing
4. **Once 10 teachers each have a healthy cohort using it**, raise funding or grow organically

The product is good enough today to start that loop. Everything else is execution.
