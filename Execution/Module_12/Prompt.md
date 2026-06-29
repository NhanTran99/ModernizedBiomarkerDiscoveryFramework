# Module 12 — Scientific Interpretation

---

## Project

**Project:** 12-Gene Gastric Cancer Signature — Part 2: Modernized Biomarker Discovery Framework

**Coding Module:** Module 12 — Scientific Interpretation

**Execution Phase**

---

# Governance

This Coding Module is governed, in precedence order, by:

1. PROJECT_GOVERNANCE_PROMPT_v4.6
2. FRAMEWORK_SPEC.md
3. IMPLEMENTATION_PHILOSOPHY_IDS_PHASE.md
4. IDS-005_Interpretability_Implementation.md
5. MODULE_TAXONOMY.md
6. IMPLEMENTATION_MASTER_PLAN.md
7. CODING_PHASE_PHILOSOPHY.md

All governing documents are LOCKED.

No governance document shall be modified or reinterpreted.

This document specializes the locked IDS-005 implementation contracts for Module 12 only. It introduces no new governance, no new framework contracts, and no modification of previous Coding Modules.

---

## Coding Prompt Consistency Check (performed before implementation)

`MODULE_12_PROMPT_SPEC.md` was checked against all previously LOCKED modules (01–11) and against IDS-005. **No conflict was identified.** Two design points were underspecified by the Spec and are clarified here for traceability:

**Clarification 1 — Interpretation Evidence's `metadata` context tags.** This is the first module of IDS-005 (Interpretability), a new domain. Resolved, continuing the layer-naming precedent established across IDS-002–IDS-004 (`"discovery"`/`"processing"` → `"modeling"` → `"validation_benchmark"`): `metadata$framework_layer = "interpretability"` (new layer, matching IDS-005's name) and `metadata$artifact_role = "interpretation_evidence"`. `contract_type` remains exactly `"artifact"`.

**Clarification 2 — Default downstream consumer.** The Spec states Module 13 is responsible for Interpretation Package construction, but does not name the `consumer` value. Resolved: defaults to `"interpretation_package"`, naming the downstream responsibility directly (consistent with how prior defaults named the downstream module's responsibility, e.g. `"benchmark"`, `"candidate_selection"`, `"interpretability"`).

No clarification was required for S3 print methods, since the Spec (Section 5) explicitly requests `print.interpretation_object()` and `print.interpretation_evidence()`.

**Implementation note:** Module 12 reuses Module 11's existing exported `validate_validated_candidate()` directly (calling, not reimplementing, the existing structural check on the consumed Validated Candidate) — this fulfills, rather than violates, the anti-duplication constraint. No Module 11 file is modified.

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

Module 12 implements the **Scientific Interpretation** responsibility of IDS-005.

Its responsibilities are limited to:

* consume Validated Candidate;
* execute Biological Interpretation workflow;
* execute Model Explanation workflow;
* construct Interpretation Object;
* construct Interpretation Evidence;
* verify Interpretation artifacts.

Module 12 SHALL NOT:

* perform Evidence Integration;
* construct Interpretation Package;
* perform Clinical Translation;
* perform scientific interpretation methodology.

Module 13 is responsible for Interpretation Package construction.

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

Module 12 follows the execution architecture established in Modules 09–11.

```text
Interpretation Workflow

↓

Interpretation Executor

↓

Interpretation Object

↓

Interpretation Evidence
```

Responsibilities remain separated.

Workflow performs orchestration only.

Executor performs execution only.

Interpretation Object captures implementation state.

Interpretation Evidence is the Framework artifact.

---

# 3. Interpretation Object

Interpretation Object is an implementation object.

Its purpose is to encapsulate:

* consumed Validated Candidate;
* interpretation components;
* execution metadata;
* execution lineage;
* implementation state.

Interpretation Object SHALL NOT be exposed as a Framework artifact.

---

# 4. Interpretation Evidence

Interpretation Evidence is the only Framework artifact produced by Module 12.

It represents the contractual Scientific Interpretation output defined by IDS-005.

Interpretation Evidence shall be structurally independent from Interpretation Object while preserving complete lineage.

Interpretation Evidence SHALL NOT contain:

* Evidence Integration;
* Interpretation Package;
* Clinical Translation;
* publication-ready interpretation.

---

# 5. Public API

Module 12 exports:

## Primary execution

```r
run_interpretation(
    interpretation_object,
    interpreter = NULL,
    ...
)
```

Responsibilities: orchestrate execution; invoke interpreter; preserve workflow lifecycle; preserve contractual lineage; construct (update) Interpretation Object; construct Interpretation Evidence.

## Constructors

```r
create_interpretation_object(
    validated_candidate
)

create_interpretation_evidence()
```

Only Validated Candidate shall be accepted as the upstream contract.

## Validators

```r
validate_interpretation_object()

validate_interpretation_evidence()
```

## Required S3 print methods

```r
print.interpretation_object()

print.interpretation_evidence()
```

---

# 6. Interpreter Callback Pattern

Module 12 follows the extensibility pattern established in Modules 07 and 09–11.

```text
run_interpretation()

↓

interpreter = NULL or user interpreter

↓

Interpretation Executor

↓

Interpretation Object
```

If `interpreter = NULL`, Module 12 shall invoke the default generic interpreter.

If an interpreter is supplied, Module 12 shall invoke the caller-provided interpreter callback.

The callback replaces only the execution step. It SHALL NOT bypass workflow, verification, lineage, or artifact construction.

---

# 7. Generic Implementation Principle

Default implementation shall remain generic.

The default interpreter performs only structural execution.

It SHALL NOT implement pathway analysis, enrichment analysis, explainability algorithms, SHAP, feature importance, biological reasoning, or scientific interpretation methodology.

Real interpretation methodology remains injectable through the interpreter callback.

---

# 8. Interpretation Component Granularity

Interpretation shall support multiple independent interpretation components.

Module 12 aggregates these components into Interpretation Evidence.

Default implementation shall produce `structural_check`.

Interpretation SHALL NOT collapse multiple components into one opaque interpretation result.

---

# 9. Artifact Consumption

Module 12 consumes only Validated Candidate.

Consumption remains read-only.

Module 12 SHALL NOT modify Validated Candidate.

Module 12 SHALL NOT directly consume Validation Evidence or Benchmark Evidence.

These artifacts remain available through preserved lineage embedded within the Validated Candidate.

---

# 10. Lineage Preservation

Module 12 preserves lineage by embedding the complete Validated Candidate.

No new lineage shall be introduced.

Complete upstream traceability shall remain preserved automatically through embedded artifacts.

---

# 11. Verification

Module 12 verifies: Interpretation Object integrity; Interpretation Evidence integrity; artifact completeness; interface compliance; lineage preservation; downstream compatibility.

Scientific correctness is explicitly outside Module 12.

---

# 12. Documentation

Document every exported API using roxygen2.

Documentation shall describe purpose, arguments, return values, and implementation semantics.

Do not document scientific interpretation methodology.

---

# 13. Testing Requirements

Tests shall verify:

* Workflow orchestration.
* Default interpreter execution.
* Custom interpreter execution.
* Interpretation Object construction.
* Interpretation Evidence construction.
* Read-only Validated Candidate consumption.
* Complete lineage preservation.
* Verification APIs.
* Multiple interpretation component support.
* Failure handling.
* Generic implementation behavior.

Tests SHALL NOT verify pathway analysis, enrichment analysis, SHAP, feature importance, biological correctness, or scientific validity.

---

# 14. Additive Constraints

Module 12 SHALL NOT modify Modules 01–11, public APIs, Framework contracts, or IDS contracts.

Module 12 is additive only.

---

# Execution History

Create:

Execution/

Module_12/

* Prompt.md
* Artifacts.md
* Execution_Log.md
* Review.md
* LOCK.md

Artifacts.md shall follow the standardized structure established in Module 01.

---

# 15. Deliverables

Implementation shall include: Interpretation workflow; Interpretation executor; Interpretation Object; Interpretation Evidence; validators; documentation; tests; execution history.

---

# 16. Definition of Done (Module-specific)

Module 12 is complete only when:

1. Interpretation workflow implemented.
2. Generic interpreter implemented.
3. Interpreter callback mechanism implemented.
4. Interpretation Object implemented.
5. Interpretation Evidence implemented.
6. Interpretation verification implemented.
7. All tests pass.
8. `devtools::check()` reports 0 ERROR / 0 WARNING.
9. Local execution succeeds.
10. Governance review passes.
11. IDS compliance passes.
12. Execution history completed.
13. Read-only consumption of Validated Candidate verified, via test, to leave it unchanged (`identical()`).
14. Interpretation Evidence verified, via test, to introduce no new Framework Contract type and to not contain Evidence Integration, Interpretation Package, Clinical Translation, or publication-ready interpretation.
15. Public API surface verified to expose exactly the 5 required functions plus the 2 required print methods — no more, no fewer.
16. Strategist Review passes.
17. Project Coordinator approves Module LOCK.

---

# Constraints

This module SHALL NOT redesign previously LOCKED modules, modify existing public APIs, duplicate implementation already owned by previous modules, or introduce functionality outside the approved module scope.

---

# Deliverables (Module Output Summary)

* Interpretation workflow / executor
* Interpretation Object implementation
* Interpretation Evidence implementation
* `validate_interpretation_object()` / `validate_interpretation_evidence()`
* Public Interpretation API
* Documentation
* Test Suite
* Execution history

---

End of Module 12 Coding Prompt (merged from MODULE_12_PROMPT_SPEC.md, post Coding Prompt Consistency Check). This module begins IDS-005 (Interpretability).
