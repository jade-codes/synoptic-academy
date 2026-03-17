# Architecture Diagrams

Visual references for implementers picking up issues. Each diagram is a standalone SVG file in `docs/img/` — click the link to view it rendered on GitHub.

---

## 1. Trust Manifold Geometry

**File:** [docs/img/trust-manifold.svg](img/trust-manifold.svg)

**What it shows:**

The geometric intuition behind GoT. The curved green band is the trust manifold M — the subspace of the Phi-weighted representation space where value directions are mutually consistent and coherent with alignment.

- Green dots (trust, care, autonomy) sit on or near M. Their geodesic distance to the manifold is close to zero. This is what an aligned model looks like geometrically.
- Red dots (harm, deception, a "trust" direction that is actually inconsistent with itself) are scattered far from M. The dashed red lines show their geodesic distance to the manifold. They are also inconsistent with each other — the arrow between them shows internal incoherence.
- The orange dashed arrow shows value drift modelled as parallel transport along M. This is the mechanism for tracking how a model's value directions shift during fine-tuning — a direction can move along the manifold (drift) or fall off it entirely (misalignment).

**Why this matters for implementers:**

When writing the linear probe and computing manifold distances, this diagram is the ground truth for what "good" looks like. A probe result where trust, care, and autonomy are tightly clustered near M and harm/deception are far from it means the Phi computation is working. If they are all scattered, the inner product implementation is probably wrong.

---

## 2. Four Rs Applied to the GoT Rust PoC

**File:** [docs/img/four-rs-got.svg](img/four-rs-got.svg)

**What it shows:**

The Four Rs development methodology (Rapid → Rigour → Refactor → Repeat) applied specifically to the GoT proof-of-concept. Each stage has a specific exit condition defined in terms of the actual GoT work, not generic milestones. The amber centre box shows what stays constant across all four stages.

- **Rapid:** Get Phi computing end-to-end. Do not worry about correctness, performance, or API design. Exit when Phi = U^T U produces output of any kind.
- **Rigour:** Design the GoT core API properly — what does the public interface look like? What types does it expose? Exit when the API is solid enough that tests can be written against it.
- **Refactor:** Validate the implementation against the numpy reference. This is not "clean up the code" — it is the moment of truth. Exit when the Rust Phi output matches the numpy reference within acceptable tolerance.
- **Repeat:** Pick the next concept (e.g. add `care` direction after `trust` is validated) and go around again.

The amber invariants in the centre (ARCHITECTURE.md, TODO.md, Claude Sonnet pair) are the context anchors that carry meaning across iterations. Do not let these drift — they are what allows AI-assisted development to stay coherent across sessions.

---

## 3. GoT to Cognitiv Integration Points

**File:** [docs/img/got-cognitiv-integration.svg](img/got-cognitiv-integration.svg)

**What it shows:**

The four specific points where GoT research feeds into Cognitiv products, and the feedback loop where real-world Cognitiv results feed back into GoT research spikes.

- **Trust manifold M → Sensemaking dashboard:** The dashboard can ask whether a group's collective value directions are coherent with each other, or whether there is hidden divergence masked by surface-level agreement. This uses the same Phi-weighted geometry as the GoT probe.
- **Value alignment probe → Divergence API:** The divergence API receives a per-concept alignment score for each viewpoint, enabling it to go beyond surface topic similarity to epistemic distance.
- **Deception detection → Hidden value divergence:** The self-inconsistency flag from the GoT deception probe surfaces cases where a viewpoint claims values it does not reflect in its reasoning.
- **GoT API → Self-inconsistency check:** The Cognitiv pipeline calls POST /v1/probe once per viewpoint and uses the result to flag viewpoints that are internally misaligned.

The dashed feedback arrow at the bottom is the most important part of this diagram for research prioritisation. When Cognitiv client sessions surface failure cases — texts where the GoT probe gives unreliable results — those cases feed directly back into GoT research spikes 2 (failure modes) and 3 (relationship to existing interpretability frameworks). This is the mechanism by which applied product work keeps the research honest.
