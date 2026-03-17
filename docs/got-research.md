# Geometry of Trust - Research & Theory

## Overview

The Geometry of Trust (GoT) is a framework for verifying AI value alignment using manifold geometry. Rather than relying on behavioural proxies or self-report, GoT constructs a geometric space over a model's value representations and uses that space to measure alignment directly.

The core thesis is that AI x-risk is fundamentally an institutional and epistemological failure upstream of any technical failure. GoT addresses the governance gap by providing a verifiable, geometry-based mechanism for value alignment that does not depend on the model behaving honestly under evaluation.

---

## Core Hypothesis

If the linear representation hypothesis holds - that models represent concepts as directions in activation space - then value-laden concepts (trust, harm, deception) should also be representable as directions. The geometry of those directions, relative to each other and to a trust manifold, should be a reliable indicator of alignment.

GoT operationalises this as follows:

1. Extract the unembedding matrix U from a transformer model
2. Construct the causal inner product Phi = U^T U
3. Use Phi as a metric on the representation space
4. Identify value directions via linear probing in the Phi-weighted space
5. Measure alignment as proximity to, and coherence on, the trust manifold M

---

## Theoretical Foundations

### The Causal Inner Product

The unembedding matrix U maps from the model's residual stream dimension to the vocabulary. Each row of U corresponds to a token; the geometry of U encodes the model's implicit beliefs about which concepts are similar, which are opposite, and which are orthogonal.

The causal inner product Phi = U^T U is a positive semi-definite matrix that captures this geometry. Unlike the raw dot product in activation space, Phi is causally grounded - it reflects the model's output behaviour, not just its internal representations.

**Open questions:**
- Is Phi positive semi-definite in practice across all model families?
- Does Phi degenerate for quantised models (GGUF 4-bit)?
- What is the relationship between Phi and the Fisher information metric on the output distribution?

### The Trust Manifold

The trust manifold M is a submanifold of the Phi-weighted representation space. Points on M correspond to value directions that are coherent with alignment - they are mutually consistent, non-deceptive, and stable under perturbation.

Alignment is measured as the geodesic distance from a model's value directions to M. A model whose value directions lie on or near M is aligned; a model whose value directions are far from M, or inconsistent with each other, is misaligned.

**Open questions:**
- What does geodesic distance on M correspond to semantically?
- Is M locally flat, positively curved, or negatively curved in practice?
- Can value drift be modelled as parallel transport on M?

### Linear Representation Hypothesis

GoT's theoretical foundations rest on the linear representation hypothesis (Park et al., 2023 - arXiv:2311.03658), which provides evidence that models represent concepts as linear directions in activation space.

**Key references:**
- Park et al. (2023) - Linear representation hypothesis
- Elhage et al. (2021) - Transformer circuits
- Alain & Bengio (2017) - Linear probing methodology
- Zou et al. (2023) - Representation engineering

**Scope and limitations:**
- The linearity finding is most robust for factual concepts; evidence for value-laden concepts is thinner
- Linearity may not hold for all model scales or architectures
- Non-linear extensions are worth investigating for future work

---

## Research Spikes

### Spike 1: Linear representation hypothesis - scope and limitations
Review Park et al. (2023) and related work to establish the current evidence base and identify where GoT's foundations are strongest and weakest. Output: internal note on implications for GoT.

### Spike 2: Failure modes - when does GoT geometry break down?
Identify conditions under which the geometric framework gives unreliable results:
- Very large or unusual vocab distributions
- Quantised models (GGUF 4-bit) - does U compress faithfully?
- Multilingual models - does the geometry hold across languages?
- Narrow-domain fine-tuned models

### Spike 3: Relationship to existing interpretability frameworks
Map GoT against mechanistic interpretability, representation engineering, TCAV, and sparse autoencoders. Identify what GoT adds, what it borrows, and where it conflicts.

---

## Positioning Against Counterarguments

| Counterargument | Response |
|---|---|
| "Geometry of token embeddings does not imply geometry of values" | GoT uses the causal inner product, not raw embeddings - it is grounded in output behaviour |
| "This is just probing with extra steps" | GoT adds a geometric structure (manifold + geodesic distance) that enables relative alignment measurement, not just binary detection |
| "A model could game the unembedding matrix while remaining misaligned" | Correct - GoT is not adversarially robust. This is documented as a limitation and a direction for future work |
| "This does not scale to multimodal or non-autoregressive models" | Current scope is autoregressive text models only. Extension to other architectures is future work |
| "Institutional failures require institutional solutions, not geometric ones" | GoT is an institutional instrument, not a replacement for governance. It provides the verifiable technical mechanism that governance frameworks currently lack |

---

## Publication & Dissemination

### Target venues
- AI safety workshops at NeurIPS, ICML, or FAccT
- Governance / policy venues: AIES, AI & Society journal
- Preprint: arXiv cs.AI or cs.LG
- AI safety fellowships: MATS, APART

### Position paper outline
1. The governance gap in AI safety
2. Why technical solutions alone are insufficient
3. The Geometry of Trust as an institutional instrument
4. Implications for AI auditing and regulation (EU AI Act, NIST RMF)
5. Open questions and limitations
