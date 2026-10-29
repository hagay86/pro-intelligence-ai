# Anthropic for Startups — Application Playbook

> **Apply at**: https://www.anthropic.com/startups
>
> **Goal**: $25K in Claude API credits to fund Phase 1 launch in Israel.
>
> **Timeline**: 2–4 weeks from submission to decision.

This file gives you (a) the strongest possible answer to every likely form field, (b) what to have ready before you hit submit, and (c) what to do after.

---

## What needs to be true before you submit

Don't submit until all of these are real:

| Item | Why it matters | Status |
|---|---|---|
| **Live public demo URL** | They click first, read second. A `localhost` URL is a fail. Deploy to Netlify (drag-drop, 5 min). | ☐ |
| **Hebrew demo working** | Differentiation = multilingual depth. Make sure the demo loads in Hebrew on first visit. | ☐ |
| **Founder LinkedIn polished** | They'll look. Position you as AI builder, not generic. | ☐ |
| **3–5 pilot creators named** | Even if uncommitted. Makes the "real product" claim defensible. | ☐ |
| **Working email signature** | `Hagay Dardik · Founder, Synapse · [demo URL]` | ☐ |
| **Company name decided** | Synapse is fine for now. Don't get stuck on this. | ☐ |

Item 1 is the killer. Skip it and your application drops 5x in quality.

---

## The application form — likely fields and draft answers

Anthropic for Startups updates their form periodically. The fields below cover what they typically ask. Adapt as the actual form requires.

### 1. Company / project name

```
Synapse
```

### 2. Website / demo URL

```
[Your Netlify or Vercel URL here, e.g. https://synapse-il.netlify.app]
```

### 3. Founder name and contact

```
Hagay Dardik
hagaydardik@gmail.com
+972-[number]
LinkedIn: [URL]
Based in: Israel
```

### 4. One-line description

```
The first product that turns a creator's relationship with Claude
into a sellable asset for their community.
```

### 5. What are you building? (longer description)

Use this verbatim or close to it (300-500 words is typical):

```
Synapse is a group-chat platform where one creator/expert leads a
community and Claude serves as the community's resident AI mentor —
instructed by the creator, grounded in the creator's actual conversations,
and capable of navigating the entire community's chat history as a
queryable knowledge base.

The core insight: Claude is now accessible to anyone for $20/month, but
the scarce resource has shifted. The creator who has spent hundreds of
hours teaching Claude their frameworks, voice, and decision patterns
is dramatically more valuable than a generic Claude user — yet today
there's no way to package and sell that relationship.

Synapse closes that gap. A creator connects their personal Claude
account via Claude Code subscription auth. Their community joins via
invite code. Members chat — with the creator, with each other, and
with the Claude instance grounded in the creator's style. Members can
ask the AI anything ("where did people discuss retargeting last month?")
and get specific messages back with attribution.

The community chat compounds in value over time — every message makes
the AI smarter for the next question. Communities migrate from Telegram
and Discord (where 50,000 messages mean nothing is findable) to Synapse
(where the AI has read every message and knows what each member is
working on).

We're launching Israel-first, in Hebrew, targeting the country's
creator economy: digital advertising experts, fitness coaches, software
architects, financial educators — people who already have an audience
and already use Claude daily for their work.

Built on Claude Sonnet 4.5 via the Claude Agent SDK with subscription
auth (not raw API keys), which we believe is a more sophisticated
integration of Anthropic's stack than most startups undertake.
```

### 6. Use case for Claude — how does it fit into your product?

```
Claude is the entire intelligence layer of Synapse. Every AI interaction
in the product is a Claude API call.

Three specific use cases drive sustained API consumption:

1. ASKED-AI MESSAGES IN COMMUNITY CHAT
   When a community member toggles "Ask AI" mode and asks a question,
   we send the full room transcript as system context with the creator's
   imported Claude conversation history. Claude returns an answer in
   the creator's voice, attributed to specific past messages.

2. PRIVATE 1:1 AI SESSIONS
   Each community member can have private Claude conversations grounded
   in the same context. This is where late-night learning happens.

3. ORGANIZE-NOTES
   On demand, the AI re-reads the entire community history and produces
   structured notes (topics covered, key frameworks, open questions,
   gaps). This is one large Claude call per community per week.

Token usage profile: long input context (full room history) + medium
output (concise answers). This is exactly where Claude's long-context
performance and instruction-following make it the right model.
```

### 7. What's unique about your application of Claude?

```
Three things:

(1) AI-RELATIONSHIP-AS-PRODUCT framing. Most AI startups treat Claude
    as a tool. Synapse treats the human-Claude relationship as the
    asset and sells access to it. To our knowledge no other product
    is built around this insight.

(2) CLAUDE CODE SUBSCRIPTION AUTH AT SCALE. We integrate via the
    Claude Agent SDK using subscription auth (not raw API keys). This
    means our users authenticate via their own Claude Pro/Max accounts
    where applicable, which we believe is the future for many B2B AI
    applications. Most startups skip this and use raw keys.

(3) HEBREW-NATIVE DEMONSTRATION. The product launches in Hebrew first.
    This demonstrates Claude's depth in a non-English language and
    serves as a proof point for Anthropic's international story.
```

### 8. Expected monthly API usage / cost projection

```
Phase 1 (months 1-3): 10 pilot creators, ~20 community members each
  - ~5,000 Claude API calls/day at full ramp
  - ~80% are short asks (1K-2K input, ~500 output tokens)
  - ~20% are long context (full room transcripts, ~50K input, ~1K output)
  - Estimated monthly cost: ~$1,500–$3,000 on Sonnet 4.5

Phase 2 (months 4-6): 50 creators, ~30 members each
  - ~30,000 API calls/day
  - Estimated monthly cost: ~$8,000–$15,000

These are conservative estimates; we'll publish actuals as we scale.
$25K in credits gives us approximately 6 months of runway at Phase 1+2
projected volume.
```

### 9. How much in credits are you requesting?

```
$25,000.

This covers approximately 6 months of API consumption through Phase 1
launch (10 paid pilot creators, real community usage) and into the
early scaling of Phase 2.

We chose this number deliberately: large enough to take pricing risk
off the table during product-market-fit discovery, small enough that
we can show meaningful ROI to Anthropic within the credits envelope.
```

### 10. Stage / traction

```
- Working prototype: live demo at [URL]
- Hebrew-native UI, RTL layout
- Built on Claude Sonnet 4.5 via Agent SDK with subscription auth
- Pre-revenue (Phase 0 — finalizing technical foundation)
- 3 pilot creators identified in advertising and SaaS verticals:
  [Names if you can share them]
- 90-day plan to ship Phase 1 publicly with paid pilot creators

We've deliberately kept the product narrow and the team small until
we have real users. Credits unlock the deployment to a real Postgres
backend and the cost cushion to onboard our first 10 paying creators
without API spend being the constraint.
```

### 11. Founder / team background

```
Hagay Dardik — founder & operator.

[Fill in your actual background — 100-200 words. Cover:
 - Years of experience in tech / software / product
 - Notable prior projects, companies, or roles
 - Israeli market knowledge (you're from there, that's an advantage)
 - Any creator economy / education adjacent experience
 - Why YOU are the right person to build this

EXAMPLE structure if you don't have it written:

"Hagay Dardik is a software builder and operator with N years of
 experience shipping products in [your domain]. Previously [previous
 role / company / project]. He has deep knowledge of the Israeli
 creator economy and personal relationships with [N] active creators
 in advertising, fitness, and SaaS who will be among Synapse's first
 customers.

 He's been using Claude daily since [date] and has spent ~[N] hours
 instructing Claude on his own work — making him both the user
 archetype and the builder for Synapse."]
```

### 12. Why now / why is this the right moment?

```
Three converging forces:

1. Creator economy at scale, hitting time wall. Every expert with
   1K+ followers wants leverage. Writing courses doesn't scale.

2. Telegram/Discord communities at scale wall. Volume of chat exceeds
   findability. Hosts have no leverage. Members can't navigate.

3. Claude's long context + accuracy make community memory queryable
   for the first time. Synapse couldn't have shipped 18 months ago.

We expect the next 12 months to see one company own this category.
We want it to be ours, and we want it built on Claude.
```

### 13. Anything else we should know?

```
Two things:

(1) We're committed to launching on Claude, not the cheapest model
    available. Our positioning ("grounded answers, no hallucination,
    creator's voice") depends on Claude's specific strengths — long
    context, instruction-following, accuracy. Pricing isn't the
    decision factor; product quality is.

(2) We'd love guidance on Claude Code subscription auth at scale.
    We're using it in production and have specific architectural
    questions that would benefit from access to whoever oversees that
    flow at Anthropic.

Thank you for reading.
```

---

## Tactical notes — what to emphasize, what to avoid

### Emphasize

- **The framing** ("AI-relationship-as-product"). It's novel; it sticks in their head.
- **Claude Code subscription auth.** Most applicants don't use this. It signals you understand the stack.
- **Israel-first / Hebrew.** Multilingual proof points are useful to Anthropic. They have weak presence here.
- **Working demo URL.** Mention it in answers 2, 5, and 10. Make it impossible to miss.
- **Token usage profile.** Be specific. "Long context + medium output" tells them you understand Claude's pricing.
- **Conservative ask ($25K).** Better to ask for a credible number than a fantasy one.

### Avoid

- **Don't ask for a partnership.** Reviewers see that as a sign you don't understand the program.
- **Don't oversell traction you don't have.** "3 pilot creators identified" is fine. "30 paying customers" if false will be checked.
- **Don't write generic AI-startup language.** "Disrupting education with AI" is the kiss of death. Be specific.
- **Don't request specific people by name.** "Please connect me to Dario" reads as naive.
- **Don't make multilingual claims you can't back up.** If Hebrew is the only non-English language, say so.

### Tone

- **Confident, not arrogant**. You know what you're building. You don't pretend it's bigger than it is.
- **Specific, not vague**. Every number, every name, every claim should be checkable.
- **Show, don't tell.** The demo URL does more work than 1,000 words of description.

---

## After you submit

**Week 1**: Expect silence. Don't follow up yet.

**Week 2**: If you have a related update — new pilot creator signed, deploy goes live, a small milestone — send a short *update* email to `startups@anthropic.com`:
> Subject: Synapse application — small update
>
> Hi team,
>
> Submitted via the form last week. Small update: [the specific thing]. Just wanted to flag it for the review. Demo at [URL].
>
> Hagay

This is not a "checking in" email. It's substantive. Don't bump just to bump.

**Week 3-4**: Decision typically comes by here. Two possible outcomes:

- **Accepted**: You'll get credit codes + sometimes an intro to a real human. **Reply within 24h**. Use the relationship — ask the one or two specific questions you most want answered.
- **Rejected**: Polite reply, ask if there's a specific gap you should close before reapplying. They sometimes give you a path. Don't take it personally — many strong startups get rejected on round one.

**No response by week 5**: One more email, polite:
> Subject: Following up on Synapse application
>
> Hi team — Submitted [date]. Wanted to make sure it didn't get lost. Demo: [URL]. Happy to wait, just confirming receipt.

Then stop. Reapply in 3-6 months with traction.

---

## What happens if you get the credits

The instant the credits land:

1. **Deploy Phase 1 for real** — Vercel + Postgres + magic-link auth. ~2 weeks of work for an experienced builder.
2. **Sign the first 3 pilot creators** — ideally on a no-commitment basis. Get them using it daily.
3. **Track everything** — daily active rooms, AI question rate, retention. These numbers become your re-pitch in 6 months.
4. **Write one public post or video** — "How Synapse uses Claude" — that makes Anthropic see real usage. Tag them.
5. **Don't waste credits on testing**. Use the API key thoughtfully. Track spend weekly.

If you do this right, in 6 months you re-engage Anthropic with:
- 10+ active creators
- Hundreds of community members
- Specific metrics (AI usage, retention, MRR if applicable)
- A real ask — this time, intros to enterprise customers or investment from Anthology Fund

The credits are the seed. Traction is the tree.

---

## Quick checklist — final pre-submit

- [ ] Demo deployed to public URL
- [ ] Demo loads in Hebrew on first visit
- [ ] Demo's interactive chat works (test it from your phone)
- [ ] LinkedIn profile updated (recent role: "Founder, Synapse")
- [ ] Founder background filled into section 11 above
- [ ] 3-5 pilot creator names listed (or "in conversation with X, Y" if not committed)
- [ ] You've re-read every answer once for tightness
- [ ] You've shown the answers to one friend whose judgment you trust
- [ ] You take 24 hours between writing and submitting — small mistakes correct themselves overnight

Then submit. Anthropic for Startups: https://www.anthropic.com/startups

---

## One more thing

The biggest mistake founders make at this stage is **waiting to submit until everything is perfect**. The application doesn't need to be perfect. It needs to be *true* and *clear* and *backed by a working demo*. If you have those three, submit. You can always reapply.

The second biggest mistake is **not following up with action after acceptance**. Getting credits is not the finish line. It's the starting gun. Have Phase 1 deployment ready to start the moment those credits arrive.
