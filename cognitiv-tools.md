# Cognitiv - Collective Intelligence Tools

## Overview

Cognitiv is the commercial consultancy arm of Synoptic Group. Where Synoptic Academy works with individuals, Cognitiv works with organisations - helping them think better collectively, surface minority views, and make decisions that reflect the actual epistemic diversity of their teams.

The PoC products sit at the intersection of collective intelligence research, AI-assisted facilitation, and systems thinking. They are designed for organisational clients who are running workshops, strategy sessions, or deliberative processes and want to understand not just what their team thinks, but how their team's thinking is structured.

---

## Product 1: Collective Sensemaking Dashboard

**Status:** Planned
**Format:** Web app (facilitator + participant views)
**Priority:** High
**Issue:** `POC: Collective sensemaking dashboard - visualise group epistemic state`

### What it does
A real-time dashboard for facilitators that visualises the collective epistemic state of a group during a workshop or deliberative session. It shows where there is consensus, where there is productive tension, and where there are blind spots.

### User flows

**Facilitator flow:**
1. Creates a session, gets a shareable join link
2. Sets a framing question
3. Watches responses cluster in real time on the dashboard
4. Sees minority views surfaced automatically
5. Exports a sensemaking report at the end

**Participant flow:**
1. Opens join link on phone or laptop
2. Submits a short response to the framing question (text, 50-200 words)
3. Optionally rates their confidence
4. Sees aggregate themes (not individual responses) after submission

### Architecture
```
┌─────────────────────────────────────┐
│  Participant UI (mobile-first)      │
│  - Response submission              │
│  - Confidence rating                │
│  - Aggregate themes view            │
└──────────────┬──────────────────────┘
               │ WebSocket
┌──────────────▼──────────────────────┐
│  Facilitator dashboard (Next.js)    │
│  - Live concept network graph       │
│  - Minority view surfacing          │
│  - Consensus / tension heatmap      │
│  - Session controls                 │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  Backend (FastAPI + Supabase)       │
│  - Session management               │
│  - Real-time response aggregation   │
│  - Clustering pipeline              │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  AI clustering layer (Claude API)   │
│  - Concept extraction               │
│  - Theme clustering                 │
│  - Minority view identification     │
│  - Sensemaking report generation    │
└─────────────────────────────────────┘
```

### Tech stack
- **Frontend:** Next.js + D3.js (network graph) + Supabase Realtime (WebSocket)
- **Backend:** Python FastAPI
- **Database:** Supabase (Postgres + Realtime)
- **AI layer:** Claude API (claude-sonnet for clustering, claude-haiku for real-time extraction)
- **Hosting:** Vercel (frontend) + Fly.io (backend)

### AI prompt design
The clustering layer needs to:
- Extract concepts from free-text responses without losing nuance
- Identify minority views that are semantically distant from the majority cluster
- Generate cluster labels that participants would recognise as fair summaries
- Produce a sensemaking report that a facilitator can use in the room

**Key design constraint:** The AI must not flatten minority views into majority clusters. The product's value is in surfacing epistemic diversity, not smoothing it away.

### Open questions
- How do we prevent the clustering from being dominated by the most confident or verbose participants?
- What is the right visual metaphor for a concept network - force-directed graph, radial layout, terrain map?
- How do we handle sensitive or conflictual responses in an organisational context?
- Should participant responses ever be visible to the facilitator individually, or only aggregated?

### Acceptance criteria
- Facilitator can create a session and share a join link in under 2 minutes
- Up to 20 participants can submit responses simultaneously
- Concept clusters visualised as a live network graph
- Minority views surfaced explicitly with a distinct visual treatment
- Sensemaking report exportable as PDF or markdown

---

## Product 2: Perspective Divergence API

**Status:** Planned
**Format:** REST API
**Priority:** High
**Issue:** `POC: Perspective divergence API - measure epistemic distance between viewpoints`

### What it does
An API that takes two or more text inputs representing different viewpoints and returns a structured analysis of epistemic distance - where they agree, where they fundamentally diverge, and what root assumptions drive the divergence.

This is core Cognitiv IP. It underpins the collective sensemaking dashboard, potential conflict mediation tooling, and organisational diagnostic products. It is also a natural complement to GoT: where GoT measures value alignment within a single model, the Perspective Divergence API measures epistemic alignment between agents.

### Endpoint design
```
POST /v1/divergence
Content-Type: application/json
Authorization: Bearer <api_key>

{
  "viewpoints": [
    "We should prioritise speed of delivery over documentation...",
    "Documentation is a prerequisite for sustainable delivery...",
    "The real issue is that we don't have shared definitions of done..."
  ],
  "context": "Engineering team discussing sprint process"
}

-> 200 OK
{
  "agreement_zones": [
    "All viewpoints value delivery outcomes"
  ],
  "divergence_zones": [
    {
      "topic": "Role of documentation",
      "positions": ["obstacle", "prerequisite", "symptom of deeper problem"],
      "divergence_type": "values"
    }
  ],
  "root_assumptions": [
    "Viewpoint 1 assumes documentation slows delivery",
    "Viewpoint 2 assumes undocumented systems create future debt",
    "Viewpoint 3 frames documentation as a proxy for a process problem"
  ],
  "suggested_reframes": [
    "What would 'good enough' documentation look like for this team?",
    "Is the disagreement about documentation or about trust in each other's work?"
  ]
}
```

### Architecture
```
┌─────────────────────────────────────┐
│  API gateway (FastAPI)              │
│  - Auth + rate limiting             │
│  - Request validation               │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  Divergence analysis pipeline       │
│  - Pairwise semantic comparison     │
│  - Root assumption extraction       │
│  - Reframe generation               │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  Claude API                         │
│  - claude-sonnet for deep analysis  │
│  - Structured JSON output           │
└─────────────────────────────────────┘
```

### Tech stack
- **API:** Python FastAPI
- **AI layer:** Claude API with structured output
- **Hosting:** Fly.io or Modal
- **SDK:** Python first, then TypeScript

### Key differentiator
Most text comparison tools measure topical similarity. The Perspective Divergence API measures **epistemic** distance - it goes below surface topic to identify the underlying assumptions and values driving divergence. This is what makes it useful for facilitation rather than just search.

### Open questions
- How do we validate that root assumption extraction is accurate and not projected?
- What is the right level of granularity - word-level, sentence-level, or argument-level comparison?
- Can this be extended to detect value divergence (complement to GoT) rather than just epistemic divergence?

### Acceptance criteria
- Returns structured divergence analysis for 2-5 viewpoints
- Root assumption identification is the key differentiator - not just topic clustering
- OpenAPI spec published before implementation
- Demo available on Cognitiv website

---

## Landscape Research Spike

**Issue:** `SPIKE: Collective intelligence tooling landscape - what exists, what is missing?`

### Tools to review

| Tool | What it does | What it misses |
|---|---|---|
| Pol.is | Consensus mapping via statement voting | No free-text, no assumption surfacing |
| Kialo | Structured argument mapping | Labour-intensive to use in live sessions |
| Loomio | Group decision making | Process-focused, not epistemic |
| Miro / FigJam | Facilitation canvas | No AI analysis layer |
| Mentimeter / Slido | Live polling | Quantitative only, no qualitative depth |
| All Our Ideas | Pairwise preference mapping | Limited to ranking, not sensemaking |

### Cognitiv's differentiated position
- Real-time epistemic mapping (not post-hoc analysis)
- Minority view surfacing as a first-class feature
- Root assumption identification (not just topic clustering)
- Systems thinking framing of group dynamics

---

## GoT Integration Point

The collective sensemaking dashboard and perspective divergence API are natural integration points for GoT. Specifically:

- **Value direction consistency:** Are the value directions in a group's collective output coherent with each other? Are there hidden value divergences masked by surface-level agreement?
- **Deception detection:** Is any viewpoint in the divergence set inconsistent with itself - i.e., does it claim values it does not reflect in its reasoning?

This positions Cognitiv as the applied, organisational face of GoT research - and creates a feedback loop between academic research and practical tooling.
