# Synoptic Academy - Platform & Curriculum

## Overview

Synoptic Academy is the education arm of Synoptic Group CIC. Its mission is to make systems thinking accessible to people who were poorly served by traditional linear institutions - the Lost Girls and Boys who have always thought non-linearly but never had language or community for it.

The platform combines structured course delivery with a living community (Discord), open learning tools, and AI-assisted facilitation. The pedagogy is built around the principle that systems thinking is not a subject to be taught but a cognitive mode to be recognised and developed.

---

## Pedagogical Framework

### Core principles
- **Why before how** - every concept is grounded in a real problem before the framework is introduced
- **Non-linear by design** - learners can enter at multiple points; content is modular not sequential
- **Community as curriculum** - much of the learning happens in discussion and collaborative sensemaking
- **AI as thinking partner** - AI tools augment facilitation rather than replace it; they ask questions, not give answers

### What "systems thinking" means here
Systems thinking at Synoptic Academy is not the academic version found in business schools. It is:
- The ability to see feedback loops in everyday situations
- Pattern recognition across domains (institutional, technical, social, ecological)
- Comfort with non-linear causality and emergence
- Epistemic humility about where the system boundary is

This is closer to Donella Meadows than to Peter Senge, and closer to the street-level version that many neurodivergent and marginalised people already use intuitively.

---

## Platform Architecture

### v0.1 - Foundation (minimal)
```
┌─────────────────────────────────────┐
│  Landing page (Next.js / Astro)     │
│  - What Synoptic Academy is         │
│  - Who it is for                    │
│  - Newsletter signup (Substack)     │
│  - Discord invite                   │
└─────────────────────────────────────┘
```

### v0.2 - First Cohort
```
┌─────────────────────────────────────┐
│  Course pages                       │
│  - Course listing                   │
│  - Individual course template       │
│  - Enrolment flow (form + email)    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  Community layer                    │
│  - Discord (already set up)         │
│  - Cohort-specific channels         │
│  - Facilitated async discussion     │
└─────────────────────────────────────┘
```

### v1.0 - Public Launch
```
┌─────────────────────────────────────┐
│  Full platform                      │
│  - Self-serve enrolment             │
│  - Learner dashboard                │
│  - Progress tracking                │
│  - Certificate of completion        │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  AI facilitation layer              │
│  - Systems map reviewer             │
│  - Socratic prompt generator        │
│  - Pattern recognition feedback     │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  Learning tools (standalone)        │
│  - Systems thinking canvas          │
│  - Pattern library                  │
└─────────────────────────────────────┘
```

### Tech stack candidates
| Component | Options | Notes |
|---|---|---|
| Frontend | Next.js, Astro | Astro preferred for content-heavy pages; Next.js if interactivity needed |
| CMS | Notion (via API), Contentlayer, MDX | Keep it simple at v0.1 |
| Auth | Clerk, NextAuth | Only needed at v0.2+ |
| Payments | Stripe | Only needed at v1.0 |
| Email | Resend + Substack | Substack for newsletter; Resend for transactional |
| Hosting | Vercel | Default choice |
| DB | Supabase (Postgres) | If state needed; avoid at v0.1 |

---

## Course 1: Introduction to Systems Thinking

### Target audience
People who have always felt like they see patterns others miss, but have never had a framework for it. Likely to include: engineers, social workers, teachers, activists, people who describe themselves as "seeing the big picture". Deliberately not framed at business analysts or management consultants.

### Learning outcomes
By the end of this course, learners will be able to:
1. Identify feedback loops in everyday systems
2. Draw a basic causal loop diagram
3. Recognise at least three common systems archetypes
4. Apply leverage point thinking to a problem they care about
5. Articulate why linear cause-and-effect thinking fails in complex systems

### Module outline (draft)

| Module | Title | Format |
|---|---|---|
| 1 | Why your brain sees systems (and most curricula don't) | Reading + video |
| 2 | Stocks, flows, and feedback - the basic vocabulary | Interactive canvas exercise |
| 3 | Reinforcing and balancing loops | Animated examples + quiz |
| 4 | Classic archetypes - patterns you've already lived | Case study + discussion |
| 5 | Leverage points - where to intervene | Workshop exercise |
| 6 | Drawing your own system | Canvas tool + peer review |
| 7 | Systems thinking in the wild | Community discussion |

### Assessment approach
No grades. Completion is evidenced by:
- Submitting a causal loop diagram of a system the learner cares about
- Participating in at least two community discussions
- Optional: writing a short reflection (shared with cohort or private)

---

## Learning Tools

### Systems Thinking Canvas
A web-based canvas for building causal loop diagrams. See `poc-demos.md` for full spec.

**Key design decisions:**
- Node types map to standard systems thinking vocabulary (stock, flow, auxiliary, feedback loop)
- Auto-detection of loop polarity (reinforcing vs balancing) reduces cognitive load
- Export to JSON enables AI reviewer integration
- No login required for basic use

### Systems Thinking Pattern Library
An interactive reference of classic archetypes with animated diagrams.

**Archetypes to cover at launch:**
1. Limits to Growth
2. Shifting the Burden
3. Tragedy of the Commons
4. Fixes that Fail
5. Escalation
6. Success to the Successful
7. Growth and Underinvestment
8. Accidental Adversaries

### AI Systems Map Reviewer
An AI tool that reviews a learner's causal loop diagram and returns structured feedback framed as a thinking partner, not a grader.

**Prompt design principles:**
- Ask questions rather than give answers ("Have you considered what happens when X reaches its limit?")
- Surface missing feedback loops as hypotheses ("There might be a balancing loop here - what do you think?")
- Name archetypes the learner may not have seen yet
- Never tell the learner their map is wrong - always frame as "another way to see it"

---

## Open Questions

- **Platform vs. tools-first:** Should we launch the platform (website + courses) or the standalone tools (canvas, pattern library) first? Tools-first may drive more organic discovery.
- **Cohort size:** What is the right first cohort size - 10, 20, 30? Smaller is more facilitable but less dynamic community.
- **Pricing model:** Free with donation? Sliding scale? Fixed fee? CIC status means we are not profit-maximising, but sustainability matters.
- **Accreditation:** Is there value in seeking accreditation (CPD, university partnership) or does that recreate the linear institution problem?
