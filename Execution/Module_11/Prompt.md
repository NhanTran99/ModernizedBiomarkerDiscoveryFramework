# Module 11 — Candidate Selection

---

## Project

**Project:** 12-Gene Gastric Cancer Signature — Part 2: Modernized Biomarker Discovery Framework

**Coding Module:** Module 11 — Candidate Selection

**Execution Phase**

---

# Governance

This Coding Module is governed, in precedence order, by:

1. PROJECT_GOVERNANCE_PROMPT_v4.6
2. FRAMEWORK_SPEC.md
3. IMPLEMENTATION_PHILOSOPHY_IDS_PHASE.md
4. IDS-004_Validation_Benchmark_Implementation.md
5. MODULE_TAXONOMY.md
6. IMPLEMENTATION_MASTER_PLAN.md
7. CODING_PHASE_PHILOSOPHY.md

All governing documents are LOCKED.

No governance document shall be modified or reinterpreted.

This document specializes the locked IDS-004 implementation contracts for Module 11 only. It introduces no new governance, no new framework contracts, and no modification of previous Coding Modules.

---

## Coding Prompt Consistency Check (performed before implementation)

`MODULE_11_PROMPT_SPEC.md` was checked against all previously LOCKED modules (01–10) and against IDS-004. **No conflict was identified.** Two design points were underspecified by the Spec and are clarified here for traceability:

**Clarification 1 — Validated Candidate's `metadata` context tags.** The Spec does not specify the `metadata$framework_layer` / `metadata$artifact_role` values for Validated Candidate. Resolved, completing the precedent established across Modules 08–10: `metadata$framework_layer = "validation_benchmark"` (same layer as Validation Evidence and Benchmark Evidence, since all three belong to IDS-004) and `metadata$artifact_role = "validated_candidate"` — completing the four-value `artifact_role` set anticipated since Module 09 (`"model_candidate"` / `"modeling_evidence"` from Module 08, `"validation_evidence"` from Module 09, `"benchmark_evidence"` from Module 10, now `"validated_candidate"`). `contract_type` remains exactly `"artifact"`.

**Clarification 2 — Default downstream consumer.** The Spec states Validated Candidate "is the final Framework artifact produced by IDS-004" but does not name its downstream consumer. Resolved: defaults to `"interpretability"`, matching `IMPLEMENTATION_MASTER_PLAN.md`'s next phase (Phase E — Interpretability, Modules 12–13), which is the next domain expected to consume IDS-004's output.

No clarification was required for S3 print methods, since the Spec (Section 5) explicitly requests `print.candidate_selection_object()` and `print.validated_candidate()`.

**Implementation note:** Module 11 reuses Module 10's existing exported `validate_benchmark_evidence()` directly (calling, not reimplementing, the existing structural check on the consumed Benchmark Evidence) — this fulfills, rather than violates, the anti-duplication constraint. No Module 10 file is modified.

No LOCKED module was modified to resolve either clarification.

---

# Roles

## Project Coordinator

* executes implementation locally
* performs local verification
* determines Module LOCK

## Coding Agent (Claude)

* implements this Coding Module only

## Strategist AI (ChatGPT)

* reviews implementation
* evaluates governance compliance
* evaluates IDS compliance
* requests revisions if necessary

---

# 1. Module Responsibility

Module 11 implements the **Candidate Selection** responsibility of IDS-004.

Its responsibilities are limited to:

* consume Benchmark Evidence;
* execute Candidate Selection workflow;
* construct Candidate Selection Object;
* construct Validated Candidate;
* verify Candidate Selection artifacts.

Module 11 SHALL NOT:

* perform scientific interpretation;
* perform biological recommendation;
* perform clinical recommendation;
* generate publication-ready conclusions;
* produce therapeutic recommendations.

Validated Candidate is the final Framework artifact produced by IDS-004.

---

# Additive-only Principle

This module extends all previously LOCKED Coding Modules.

No locked implementation may be modified.

Only additive implementation is permitted.

---

# Stable API Principle

Previously established public APIs SHALL retain their function names, parameter semantics, return semantics, and implementation responsibilities.

This module may consume existing APIs but SHALL NOT redefine them.

---

# 2. Architectural Pattern

Module 11 follows the same execution architecture established in Modules 09–10.

```text
Candidate Selection Workflow

↓

Candidate Selection Executor

↓

Candidate Selection Object

↓

Validated Candidate
```

Responsibilities remain separated.

Workflow performs orchestration only.

Executor performs execution only.

Candidate Selection Object captures implementation state.

Validated Candidate is the Framework artifact.

---

# 3. Candidate Selection Object

Candidate Selection Object is an implementation object.

Its purpose is to encapsulate:

* consumed Benchmark Evidence;
* selection components;
* execution metadata;
* execution lineage;
* implementation state.

Candidate Selection Object SHALL NOT be exposed as a Framework artifact.

---

# 4. Validated Candidate

Validated Candidate is the only Framework artifact produced by Module 11.

It represents the contractual Candidate Selection output defined by IDS-004.

Validated Candidate shall be structurally independent from Candidate Selection Object while preserving complete lineage.

Validated Candidate SHALL NOT contain:

* scientific interpretation;
* biological recommendation;
* clinical recommendation;
* publication-ready conclusions;
* therapeutic recommendations.

---

# 5. Public API

Module 11 exports:

## Primary execution

```r
run_candidate_selection(
    candidate_selection_object,
    selector = NULL,
    ...
)
```

Responsibilities: orchestrate execution; invoke selector; preserve workflow lifecycle; preserve contractual lineage; construct (update) Candidate Selection Object; construct Validated Candidate.

## Constructors

```r
create_candidate_selection_object()

create_validated_candidate()
```

## Validators

```r
validate_candidate_selection_object()

validate_validated_candidate()
```

## Required S3 print methods

```r
print.candidate_selection_object()

print.validated_candidate()
```

---

# 6. Selector Callback Pattern

Module 11 follows the extensibility pattern established in Modules 07, 09 and 10.

```text
run_candidate_selection()

↓

selector = NULL or user selector

↓

Candidate Selection Executor

↓

Candidate Selection Object
```

If `selector = NULL`, Module 11 shall invoke the default generic selector.

If a selector is supplied, Module 11 shall invoke the caller-provided selector callback.

The callback replaces only the execution step. It SHALL NOT bypass workflow, verification, lineage, or artifact construction.

---

# 7. Generic Implementation Principle

Default implementation shall remain generic.

The default selector performs only structural execution.

It SHALL NOT implement ranking, score optimization, statistical comparison, biological interpretation, clinical recommendation, or machine learning methodology.

Real selection methodology remains injectable through the selector callback.

---

# 8. Selection Granularity

Candidate Selection shall support multiple independent selection components.

Module 11 aggregates these components into a Validated Candidate.

Candidate Selection SHALL NOT collapse multiple components into one opaque decision.

---

# 9. Artifact Consumption

Module 11 consumes only Benchmark Evidence.

Consumption remains read-only.

Module 11 SHALL NOT modify Benchmark Evidence.

Module 11 SHALL NOT directly consume Validation Evidence, Model Candidate, Training Object, or Modeling Evidence.

---

# 10. Verification

Module 11 verifies: Candidate Selection Object integrity; Validated Candidate integrity; artifact completeness; interface compliance; lineage preservation; downstream compatibility.

Scientific validity is explicitly outside Module 11.

---

# 11. Documentation

Document every exported API using roxygen2.

Documentation shall describe purpose, arguments, return values, and implementation semantics.

Do not document scientific or downstream interpretation.

---

# 12. Testing Requirements

Tests shall verify:

* Workflow orchestration.
* Default selector execution.
* Custom selector execution.
* Candidate Selection Object construction.
* Validated Candidate construction.
* Read-only Benchmark Evidence consumption.
* Complete lineage preservation.
* Verification APIs.
* Multiple selection component support.
* Failure handling.
* Generic implementation behavior.

Tests SHALL NOT verify ranking methodology, statistical correctness, scientific validity, biological interpretation, or clinical recommendation.

---

# 13. Additive Constraints

Module 11 SHALL NOT modify Modules 01–10, public APIs, Framework contracts, or IDS contracts.

Module 11 is additive only.

---

# Execution History

Create:

Execution/

Module_11/

* Prompt.md
* Artifacts.md
* Execution_Log.md
* Review.md
* LOCK.md

Artifacts.md shall follow the standardized structure established in Module 01.

---

# 14. Deliverables

Implementation shall include: Candidate Selection workflow; Candidate Selection executor; Candidate Selection Object; Validated Candidate; validators; documentation; tests; execution history.

---

# 15. Definition of Done (Module-specific)

Module 11 is complete only when:

1. Candidate Selection workflow implemented.
2. Generic selector implemented.
3. Selector callback mechanism implemented.
4. Candidate Selection Object implemented.
5. Validated Candidate implemented.
6. Candidate Selection verification implemented.
7. All tests pass.
8. `devtools::check()` reports 0 ERROR / 0 WARNING.
9. Local execution succeeds.
10. Governance review passes.
11. IDS compliance passes.
12. Execution history completed.
13. Read-only consumption of Benchmark Evidence verified, via test, to leave it unchanged (`identical()`).
14. Validated Candidate verified, via test, to introduce no new Framework Contract type and to not contain scientific interpretation, biological recommendation, clinical recommendation, publication-ready conclusions, or therapeutic recommendations.
15. Public API surface verified to expose exactly the 5 required functions plus the 2 required print methods — no more, no fewer.
16. Strategist Review passes.
17. Project Coordinator approves Module LOCK.

---

# Constraints

This module SHALL NOT redesign previously LOCKED modules, modify existing public APIs, duplicate implementation already owned by previous modules, or introduce functionality outside the approved module scope.

---

# Deliverables (Module Output Summary)

* Candidate Selection workflow / executor
* Candidate Selection Object implementation
* Validated Candidate implementation
* `validate_candidate_selection_object()` / `validate_validated_candidate()`
* Public Candidate Selection API
* Documentation
* Test Suite
* Execution history

---

End of Module 11 Coding Prompt (merged from MODULE_11_PROMPT_SPEC.md, post Coding Prompt Consistency Check). This module closes IDS-004 (Validation & Benchmark) in full.
