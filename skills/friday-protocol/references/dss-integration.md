# 🧠 MemoriaGraph 3.1 DSS & Cognitive Closed-Loop Guide

In **Cognitive Mode**, FRIDAY-PROTOCOL establishes a bidirectional cognitive feedback loop between the agent and the Neo4j MemoriaGraph 3.1 Cognitive Graph.

---

## 1. Phase 1 Inflow: Precedent & Decision Support (DSS)

Before authoring an Implementation Plan, the agent must query MemoriaGraph to retrieve past architectural decisions and avoid repeating historical mistakes:

```python
# 1. Query Decision Precedents
memoriagraph.recall(mode="dss", query="<feature_name_or_domain>")

# 2. Synthesize Heuristics & Solution Patterns
memoriagraph.reflect(action="reflect", question="What are the proven design patterns for <domain>?")
```

### Questions the DSS Answers:
- Have we implemented a similar subsystem in previous episodes?
- What edge-cases or server constraints (PM2, Tailscale, Redis) were encountered?
- What conventions does the Operator prefer for this codebase?

---

## 2. Phase 8 Outflow: Cognitive Crystallization & Training

Once the implementation has passed both SAST and Empirical UAT, the agent sets the knowledge permanently into the graph:

```python
# 1. Retain New Solution & Architectural Decision
memoriagraph.retain(
    bank_id="general",  # or 'infra-sre', 'csirt-security'
    category="PROBLEM_SOLVING",
    title="Implementation of <Feature>",
    decision="Architectural choice made and trade-offs weighed",
    heuristic="Rule of thumb derived for future episodes",
    content="Full technical summary and verified working pattern"
)

# 2. Reinforce Heuristic Weights
memoriagraph.reflect(
    action="reinforce",
    target_id="<heuristic_or_belief_id>"
)
```

### The Result: Continual Learning
Every successful deployment makes the agent smarter, faster, and more aligned with the Operator's specific infrastructure.
