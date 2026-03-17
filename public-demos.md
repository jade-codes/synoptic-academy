# Public-Facing Demos

## Overview

The public demos are the most important near-term deliverables for credibility and growth. Before any course is live, before any paper is published, before any funding is secured - the demos are what make Synoptic Group real to an external audience.

Each demo has a specific job. Together they cover the three audiences that matter most right now: technical/research (GoT explainer + live probe), general public and learners (Synoptic Academy intro), and funders/policy makers (all four, but especially the GoT explainer and the minimum demo stack).

---

## Demo 1: GoT Interactive Explainer

**Status:** Planned
**Format:** Scrollytelling web page
**Priority:** High
**Issue:** `POC: Interactive GoT explainer - what is the Geometry of Trust?`

### Job to be done
Make GoT comprehensible and compelling to a technically literate but non-specialist audience. This is the asset that gets shared after a conference talk, embedded in a grant application, or sent to a policy maker.

### Structure
```
Section 1: The problem
  "How do you know what an AI actually values?"
  - Animated: a model saying one thing, doing another
  - The limits of behavioural testing

Section 2: The geometry
  "Values are directions in space"
  - Animated: token embeddings as points, concepts as directions
  - The linear representation hypothesis in plain English

Section 3: The trust manifold
  "What alignment looks like geometrically"
  - Animated: the manifold, aligned vs misaligned directions
  - Geodesic distance as an alignment score

Section 4: The tool
  "What GoT tells you that nothing else does"
  - Live or pre-computed demo probe result
  - Comparison: behavioural testing vs geometric verification

Section 5: What's next
  - Link to paper / preprint
  - Link to GitHub
  - Mailing list signup
```

### Architecture
```
┌─────────────────────────────────────┐
│  Static web page                    │
│  - Next.js or plain HTML/CSS/JS     │
│  - Scrollama for scroll triggers    │
│  - D3 or Three.js for animations    │
│  - No backend required (static)     │
└─────────────────────────────────────┘
```

### Tech stack
- **Framework:** Next.js (static export) or plain HTML
- **Scroll triggers:** Scrollama or Intersection Observer API
- **Animations:** D3.js (2D geometry animations) or Three.js (3D manifold)
- **Hosting:** Vercel or GitHub Pages
- **No backend** - all animations are pre-computed or generative (no model inference)

### Design principles
- Mobile responsive (many policy audiences read on phones)
- Accessible - animations must have text fallbacks
- No jargon without immediate plain English explanation
- The tone is confident but not arrogant - "here is what we found" not "we have solved alignment"

### Success criteria (qualitative)
- A technically literate non-specialist can explain GoT to a colleague after reading it
- At least one person says "I've never seen alignment explained this way before"
- A policy maker says "I could use this in a briefing"

### Acceptance criteria
- Comprehensible to a technically literate non-specialist (tested with at least 2 readers)
- Mobile responsive
- Load time under 3 seconds
- Linked from GoT GitHub repo and Tech Unfiltered Substack

---

## Demo 2: Synoptic Academy Interactive Intro

**Status:** Planned
**Format:** Interactive web experience
**Priority:** High
**Issue:** `POC: Synoptic Academy interactive intro - what is systems thinking?`

### Job to be done
Make the right person feel seen. The primary goal is not to explain systems thinking - it is to make the Lost Girls and Boys recognise themselves and feel like they have found their people.

### Structure
```
Opening: A broken system they recognise
  - Choose your context: NHS, a failing project, a city traffic system
  - Linear framing: "here is the obvious cause and effect"
  - "But that's not how it actually works, is it?"

Middle: The systems view
  - Reveal the feedback loops they already sensed
  - "You already knew something was wrong. Here is why."
  - Causal loop diagram builds in real time

Twist: This is how you already think
  - "Systems thinkers are not taught. They are recognised."
  - Short self-assessment: do you see these patterns?

End: You belong here
  - "This is what we teach at Synoptic Academy"
  - Discord invite
  - Email capture: "Get notified when the first course opens"
```

### Architecture
```
┌─────────────────────────────────────┐
│  Interactive web experience         │
│  - React (state-driven interactivity│
│  - Framer Motion for animations     │
│  - SVG causal loop diagram (D3)     │
│  - Supabase for email capture       │
└─────────────────────────────────────┘
```

### Tech stack
- **Framework:** React (Next.js)
- **Animation:** Framer Motion
- **Diagram:** D3.js SVG causal loop diagram
- **Email capture:** Substack embed or Supabase + Resend
- **Hosting:** Vercel

### Design principles
- The tone is warm, direct, and slightly wry - not corporate
- No systems thinking jargon until the learner has already demonstrated the thinking
- The reveal ("you already think this way") is the emotional core - do not rush it
- British English throughout

### Success criteria (qualitative)
- At least 3 out of 5 test readers say "this is exactly how I think"
- At least 1 test reader says "I wish I'd found this years ago"
- Email capture conversion rate above 30%

---

## Demo 3: Live GoT Probe

**Status:** Planned
**Format:** Web app (single page)
**Priority:** High
**Issue:** `POC: Live GoT probe demo - try it on any text`

### Job to be done
Let anyone try GoT on real text in under 60 seconds. Creates shareable outputs and gives technical and policy audiences a concrete artefact to discuss.

### What it looks like
```
┌─────────────────────────────────────┐
│  "Paste any text. See its values."  │
│                                     │
│  [ Large text input area ]          │
│                                     │
│  Try: AI system prompt / policy     │
│       document / company values     │
│                                     │
│  [ Probe this text ]                │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  Results                            │
│  - Radar chart: trust / harm /      │
│    deception / autonomy / care      │
│  - Manifold distance score          │
│  - Plain English interpretation     │
│  - "Share these results" URL        │
└─────────────────────────────────────┘
```

### Architecture
```
┌─────────────────────────────────────┐
│  Frontend (Next.js)                 │
│  - Text input                       │
│  - Radar chart (Recharts or D3)     │
│  - Shareable results URL            │
└──────────────┬──────────────────────┘
               │ REST
┌──────────────▼──────────────────────┐
│  GoT API (Product 4 in got-poc.md)  │
│  - Rate limited (10 req/hour/IP)    │
│  - Pre-computed for demo model      │
└─────────────────────────────────────┘
```

### Tech stack
- **Frontend:** Next.js
- **Visualisation:** Recharts radar chart or D3
- **Backend:** GoT API (shared with VS Code extension)
- **Rate limiting:** Upstash Redis
- **Results sharing:** Hash-based URL (no auth required)

### Acceptance criteria
- Works on any plain text input up to 2000 words
- Results returned in under 15 seconds
- Output is visually clear and self-explanatory without reading the docs
- Rate limited at 10 requests per hour per IP
- Shareable results URL

---

## Demo 4: Minimum Demo Stack Spike

**Issue:** `SPIKE: What is the minimum demo stack to get GoT in front of funders by Q3?`

### The question
What is the smallest set of working demos that makes GoT credible to a non-technical funder or policy audience by Q3 2025?

### Constraints
- Must run without a local GPU (hosted or WASM)
- Must be self-explanatory without a live walkthrough
- Must be visually polished enough to embed in a grant application or one-pager

### Candidate minimum stack

| Demo | Build effort | Funder impact | Decision |
|---|---|---|---|
| GoT explainer (static, no live probe) | Low | High | **Include** |
| Live probe (hosted API, small model) | Medium | High | **Include if API is ready** |
| Synoptic Academy intro | Medium | Medium (different audience) | **Include** |
| VS Code extension | High | Low (too technical) | **Defer** |
| Dashboard (Cognitiv) | High | Medium | **Defer** |

### Pre-computed fallback
If the hosted API is not ready by Q3, the live probe demo can use pre-computed results for a fixed set of example texts (AI system prompts, policy documents, company values statements). This is a legitimate demo - it shows the output format and the interpretive layer even without live inference.

### Output of spike
A one-page demo roadmap with: what to build, what to fake, what to defer, and what the critical path dependency is.
