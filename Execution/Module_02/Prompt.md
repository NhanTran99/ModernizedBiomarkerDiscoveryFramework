# Module 02 — Framework Contracts

---

## Project

**Project:** 12-Gene Gastric Cancer Signature — Part 2: Modernized Biomarker Discovery Framework

**Coding Module:** Module 02 — Framework Contracts

**Execution Phase**

---

# Governance

This Coding Module is governed, in precedence order, by:

1. PROJECT_GOVERNANCE_PROMPT_v4.6
2. FRAMEWORK_SPEC.md
3. IMPLEMENTATION_PHILOSOPHY_IDS_PHASE.md
4. IDS-001_Framework_Implementation.md
5. MODULE_TAXONOMY.md
6. IMPLEMENTATION_MASTER_PLAN.md
7. CODING_PHASE_PHILOSOPHY.md

All governing documents are LOCKED.

This Coding Module shall implement only the Framework Contracts responsibility defined for Module 02.

No governance document may be modified or reinterpreted.

---

# Roles

Project Coordinator

* executes implementation locally
* performs local verification
* determines Module LOCK

Coding Agent (Claude)

* implements Framework Contracts only

Strategist AI (ChatGPT)

* reviews implementation
* evaluates governance and IDS compliance
* requests revisions when necessary

---

# Module Responsibility

Implement the reusable Framework Contract Layer required by all downstream Coding Modules.

This module establishes the common contract representation used throughout the framework.

No Discovery, Modeling, Validation, Interpretability or Clinical Translation functionality shall be implemented.

---

# Additive-only Principle

Module 02 extends the repository created in Module 01.

It shall not overwrite or redesign previously locked implementation.

Module 02 may only add new framework capability.

---

# Stable API Principle

All public APIs introduced by this module are considered stable framework APIs.

After Module 02 is LOCKED:

* function names shall remain stable
* parameter semantics shall remain stable
* returned object structure shall remain stable

Future modules may extend these APIs but shall not break them.

---

# Contract-first Principle

All downstream modules shall construct framework artifacts exclusively through the Framework Contract Layer created here.

No downstream module shall create contract objects independently.

Framework Contracts become the canonical object model for the project.

---

# Contract Representation

Framework contracts shall be represented using base R lists.

No R6 classes.

No S4 classes.

No external object systems.

Each contract shall follow the common schema:

* contract_type
* producer
* consumer
* inputs
* outputs
* dependencies
* metadata

This schema shall be shared consistently across all contract types.

---

# Required Source Files

Create the following files under:

R/

* artifact_contract.R
* interface_contract.R
* dependency_contract.R
* verification_contract.R
* validators.R

---

# Required Public API

For every contract type implement:

Constructor

* create_xxx_contract()

Validator

* validate_xxx_contract()

Predicate

* is_xxx_contract()

Print method

* print.xxx_contract()

Naming shall remain consistent throughout the framework.

---

# Validation

Validators shall verify only:

* required fields
* object completeness
* structural consistency
* contract integrity

Validators SHALL NOT perform:

* scientific validation
* statistical validation
* algorithm validation
* biological validation
* runtime benchmarking

Use base R:

* stop()
* warning()
* message()

No custom condition framework.

---

# Documentation

Document all exported public APIs using roxygen2.

Documentation shall describe:

* purpose
* arguments
* return value
* contract semantics

Do not describe framework architecture beyond the implemented API.

---

# Tests

Create:

tests/testthat/

* test-artifact-contract.R
* test-interface-contract.R
* test-dependency-contract.R
* test-verification-contract.R

Tests shall verify:

* constructor works
* validator accepts valid contracts
* validator rejects invalid contracts
* predicates behave correctly
* print methods execute successfully

No Discovery tests.

No Modeling tests.

No algorithmic tests.

---

# Execution History

Create:

Execution/

Module_02/

* Prompt.md
* Artifacts.md
* Execution_Log.md
* Review.md
* LOCK.md

Artifacts.md shall follow the same standardized structure established in Module 01.

---

# In Scope

This module SHALL:

* implement reusable Framework Contracts
* implement validators
* implement predicates
* implement print methods
* implement contract documentation
* implement framework contract tests
* establish the canonical contract API

---

# Out of Scope

This module SHALL NOT implement:

* Discovery
* Modeling
* Validation
* Benchmarking
* Interpretability
* Clinical Translation
* algorithms
* machine learning
* statistical analysis
* feature engineering
* visualization
* logging framework
* helper utilities unrelated to Framework Contracts
* GitHub Actions
* CI/CD
* Docker

---

# Success Criteria

Framework Contracts compile successfully.

Package loads successfully.

All contract APIs are available.

All validators operate correctly.

All predicates operate correctly.

All print methods operate correctly.

All tests pass.

Repository remains additive relative to Module 01.

---

# Definition of Done

Module 02 is complete only if:

1. Framework Contract Layer implemented.
2. Stable API established.
3. Contract-first architecture established.
4. All contract types implemented.
5. Validators implemented.
6. Predicates implemented.
7. Print methods implemented.
8. Documentation generated successfully.
9. Tests pass.
10. Local execution succeeds.
11. Governance compliance passes.
12. IDS compliance passes.
13. Repository remains additive.
14. Execution history updated.
15. Strategist Review passes.
16. Project Coordinator approves Module LOCK.

---

# Constraints

Do not redesign Module 01.

Do not anticipate downstream scientific implementation.

Do not introduce framework utilities unrelated to contracts.

Do not create business logic.

Implement the reusable Framework Contract Layer only.

---

# Deliverables

* Framework Contract Layer
* Validation Layer
* Contract API
* Documentation
* Test Suite
* Execution history templates

No additional functionality shall be introduced.

---

End of Module 02 Coding Prompt.
