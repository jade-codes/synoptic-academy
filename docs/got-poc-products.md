# Geometry of Trust - PoC Products

## Overview

This document covers the planned proof-of-concept products built on top of the GoT framework. The goal is to move from research artefact to usable tools - demonstrating that GoT is not just theoretically interesting but practically applicable.

The PoC products are ordered by priority. The CLI and web dashboard are the highest leverage: the CLI proves technical viability to a developer audience; the dashboard proves communicability to a non-technical audience.

---

## Product 1: GoT CLI

**Status:** Planned
**Format:** CLI tool (Rust)
**Priority:** High
**Issue:** `POC: GoT CLI - run alignment probe against a local model`

### What it does
Takes a local model and a set of value concept definitions, runs the GoT probe, and outputs a trust geometry report.

```bash
got-audit --model ./models/mistral-7b.gguf --concepts trust,harm,deception --output report.json
```

### Architecture
```
┌─────────────────────────────────────┐
│  CLI (clap)                         │
│  - Parse args                       │
│  - Load concepts config             │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  Model loader                       │
│  - Load GGUF / safetensors          │
│  - Extract unembedding matrix U     │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  GoT core (lib)                     │
│  - Compute Phi = U^T U              │
│  - Run linear probes per concept    │
│  - Compute manifold distances       │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  Report serialiser                  │
│  - JSON output                      │
│  - Human-readable summary           │
└─────────────────────────────────────┘
```

### Tech stack
- **Language:** Rust
- **Inference / weight loading:** candle or llama-cpp-rs (spike required - see got-research.md)
- **Linear algebra:** nalgebra or ndarray
- **CLI parsing:** clap
- **Serialisation:** serde + serde_json

### Open questions
- Which Rust inference library gives access to weight tensors without a full forward pass?
- What is the runtime on a consumer GPU for a 7B model?
- Should concept definitions be hardcoded, loaded from TOML, or passed inline?

### Acceptance criteria
- Runs end-to-end on at least one open model
- JSON report with trust manifold distances per concept
- README with install and usage instructions
- Sub-5 minute runtime on a mid-range GPU

---

## Product 2: GoT Web Dashboard

**Status:** Planned
**Format:** Web app
**Priority:** High
**Issue:** `POC: GoT web dashboard - visualise trust geometry for a model`

### What it does
An interactive web dashboard that visualises the trust manifold for a given model - showing value directions, geodesic distances, and alignment scores in a 2D/3D projection.

### Architecture
```
┌─────────────────────────────────────┐
│  Frontend (Next.js)                 │
│  - Model / concept selection        │
│  - 3D manifold visualisation        │
│  - Per-concept drill-down           │
│  - Shareable URL per run            │
└──────────────┬──────────────────────┘
               │ REST / WebSocket
┌──────────────▼──────────────────────┐
│  API server (Python FastAPI)        │
│  - Job queue for probe runs         │
│  - Calls GoT core via FFI or CLI    │
│  - Returns projection coordinates  │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  GoT core (Rust, same as CLI)       │
│  - Phi computation                  │
│  - Linear probes                    │
│  - Manifold distance                │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  Dimensionality reduction           │
│  - UMAP or PCA to 3D                │
│  - Coordinates returned to frontend │
└─────────────────────────────────────┘
```

### Tech stack
- **Frontend:** Next.js + Three.js (3D) or Plotly.js (simpler)
- **Backend:** Python FastAPI
- **GoT core:** Rust (called via CLI subprocess or PyO3 bindings)
- **Dimensionality reduction:** UMAP (via umap-learn) or PCA (scikit-learn)
- **Hosting:** Vercel (frontend) + Fly.io or Modal (backend)

### Open questions
- Which dimensionality reduction method best preserves trust manifold structure?
- Can this run in-browser via WASM for the demo case? (see WASM spike)
- What is the right visual metaphor for a trust manifold - constellation, terrain, network?

### Acceptance criteria
- Interactive 3D plot of value directions for at least 3 concepts simultaneously
- Shareable URL per model/concept combination
- Loads in under 10 seconds for a pre-computed model

---

## Product 3: GoT VS Code Extension

**Status:** Planned
**Format:** VS Code extension
**Priority:** Medium
**Issue:** `POC: GoT VS Code extension - inline alignment indicators`

### What it does
Shows inline alignment indicators in VS Code when writing prompts or reviewing AI-generated output. A trust score appears in the status bar; hovering shows which value directions are active.

### Architecture
```
┌─────────────────────────────────────┐
│  VS Code Extension (TypeScript)     │
│  - Text selection listener          │
│  - Status bar item                  │
│  - Hover provider                   │
└──────────────┬──────────────────────┘
               │ HTTP
┌──────────────▼──────────────────────┐
│  Local GoT server (same as API PoC) │
│  - Lightweight probe endpoint       │
│  - Returns score + active concepts  │
└─────────────────────────────────────┘
```

### Tech stack
- **Extension:** TypeScript (VS Code Extension API)
- **Backend:** GoT API (Product 4 below) running locally
- **UX:** Status bar for score, hover panel for detail

### Open questions
- Can a lightweight GoT probe run fast enough for near-real-time feedback (< 2s)?
- What is the right UX for trust indicators - should it be opt-in per selection, or always-on?
- How does this interact with Continue.dev and Copilot extensions?

### Acceptance criteria
- Installable from VSIX
- Trust score in status bar for selected text
- Latency under 2 seconds against a local model

---

## Product 4: GoT API

**Status:** Planned
**Format:** REST API
**Priority:** Medium
**Issue:** `POC: GoT API - hosted alignment probe endpoint`

### What it does
A hosted REST API that accepts a model identifier and text, and returns a GoT alignment report. Enables third-party integration and underpins the VS Code extension and web dashboard.

### Endpoint design
```
POST /v1/probe
Content-Type: application/json
Authorization: Bearer <api_key>

{
  "model": "mistral-7b",
  "text": "...",
  "concepts": ["trust", "harm", "deception"]
}

-> 200 OK
{
  "scores": {
    "trust": 0.82,
    "harm": 0.14,
    "deception": 0.07
  },
  "manifold_distance": 0.23,
  "interpretation": "High trust alignment. Low harm activation.",
  "model": "mistral-7b",
  "probe_version": "0.1.0"
}
```

### Architecture
```
┌─────────────────────────────────────┐
│  API gateway (FastAPI)              │
│  - Auth (API key)                   │
│  - Rate limiting                    │
│  - Request validation               │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  Job queue (Redis + worker)         │
│  - Async probe execution            │
│  - Result caching per model+text    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│  GoT core (Rust)                    │
│  - Called via PyO3 or subprocess    │
└─────────────────────────────────────┘
```

### Tech stack
- **API:** Python FastAPI
- **Queue:** Redis + Celery or ARQ
- **GoT core:** Rust (PyO3 bindings preferred over subprocess)
- **Auth:** API key via header
- **Hosting:** Fly.io, Modal, or Railway
- **SDK:** Python (first), Rust (second)

### Open questions
- PyO3 bindings vs subprocess - which is more maintainable at this stage?
- What models should be available hosted vs. user-supplied?
- Pricing model for Cognitiv: per-probe, subscription, or enterprise only?

### Acceptance criteria
- OpenAPI spec written before implementation
- Live endpoint on a public URL, rate-limited (10 req/hour free tier)
- Python SDK published to PyPI
- Rust SDK published to crates.io

---

## Architecture Spike: WASM feasibility

**Issue:** `SPIKE: Could GoT run entirely in-browser via WASM?`

### Why this matters
An in-browser demo with no backend is the lowest-friction public demo possible. Critical for conferences and non-technical funders.

### What to investigate
- Can the Rust GoT core (Phi computation + linear probe) compile to `wasm32-unknown-unknown`?
- What is the memory footprint for a small model (Phi-2 at 2.7B, TinyLlama at 1.1B)?
- Are there WASM-compatible Rust linear algebra crates? (nalgebra supports WASM; ndarray may not)
- What is the runtime for a WASM probe vs native?

### Decision criteria
| Outcome | Decision |
|---|---|
| WASM feasible, < 30s runtime, < 500MB memory | Build WASM demo as primary public demo |
| WASM feasible but slow | Use WASM for tiny models only; hosted API for full models |
| WASM not feasible | Use hosted API with pre-computed results for demo |
