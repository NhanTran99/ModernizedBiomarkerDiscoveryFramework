# Module 01 — Repository Bootstrap

---

## Project

**Project:** 12-Gene Gastric Cancer Signature — Part 2: Modernized Biomarker Discovery Framework

**Coding Module:** Module 01 — Repository Bootstrap

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

These documents are LOCKED.

This Coding Prompt SHALL NOT modify or reinterpret any governance document.

---

# Roles

Project Coordinator

* approves Coding Prompt
* executes implementation locally
* determines Module LOCK

Coding Agent (Claude)

* implements this Coding Module only

Strategist AI (ChatGPT)

* reviews implementation
* evaluates governance compliance
* requests revisions if necessary

---

# Module Responsibility

Implement **Repository Bootstrap** only.

Purpose:

Prepare the execution environment and repository structure required for all downstream Coding Modules.

No framework implementation is permitted.

No implementation contracts are introduced.

No framework redesign is permitted.

---

# Repository Type

Create a standard R package.

Package name:

GCSignatureFramework

---

# Technical Requirements

Use:

* R 4.4
* renv
* roxygen2
* testthat (Edition 3)

License:

MIT

---

# Required Repository Structure

Create the repository bootstrap containing at minimum:

GCSignatureFramework/

* R/
* man/
* tests/
* vignettes/
* inst/
* config/
* dev/
* data/
* output/

  * logs/

Root files:

* DESCRIPTION
* NAMESPACE
* README.md
* .gitignore
* .Rbuildignore

Configuration:

config/

* config.yml

Execution history:

Execution/

Module_01/

* Prompt.md
* Artifacts.md
* Execution_Log.md
* Review.md
* LOCK.md

---

# README

Create a README skeleton only.

Do not write complete documentation.

Include only:

* Project title
* Short description
* Repository overview
* Installation placeholder
* Repository structure
* TODO placeholders for future documentation

---

# roxygen2

Configure the package to use roxygen2.

NAMESPACE and documentation shall be generated through roxygen2.

Do not manually maintain NAMESPACE.

Do not manually create Rd documentation.

---

# testthat

Initialize testthat (Edition 3).

Bootstrap testing only.

No algorithmic tests.

No framework tests.

No scientific validation tests.

---

# renv

Initialize renv.

Create a reproducible package environment.

---

# Execution History

Create the Module_01 execution history directory.

Artifacts.md shall contain the following sections:

* Module
* Purpose
* Inputs
* Outputs
* Files Created
* Files Modified
* Files Removed
* Produced Artifacts
* Verification Results
* Downstream Dependencies
* Notes

Execution_Log.md, Review.md and LOCK.md shall be created as templates for subsequent completion by the Project Coordinator and Strategist AI.

---

# In Scope

This module SHALL:

* initialize the repository
* initialize the package
* configure renv
* configure roxygen2
* configure testthat
* create the agreed repository structure
* create README skeleton
* create configuration directory
* create Execution history structure

---

# Out of Scope

This module SHALL NOT create:

* framework contracts
* IDS implementation
* algorithms
* statistical methods
* machine learning models
* helper functions
* utility functions
* logging framework
* visualization
* data processing
* feature engineering
* benchmark implementation
* validation implementation
* interpretability implementation
* clinical translation implementation
* GitHub Actions
* CI/CD
* Docker
* any implementation outside Repository Bootstrap

---

# Success Criteria

Repository successfully initializes as an R package.

renv initializes successfully.

roxygen2 is configured.

testthat Edition 3 is configured.

README skeleton exists.

Repository structure matches the agreed architecture.

Execution history structure exists.

---

# Definition of Done

Module 01 is complete only if all of the following are satisfied:

1. Repository bootstrap implementation completed.
2. Package loads successfully.
3. Local execution completed successfully.
4. Repository structure conforms to this specification.
5. No implementation exceeds Module 01 responsibility.
6. Governance compliance passes.
7. IDS compliance passes.
8. Downstream readiness confirmed.
9. Execution history updated.
10. Strategist Review passes.
11. Project Coordinator approves Module LOCK.

---

# Constraints

Claude shall implement only this Coding Module.

Do not anticipate future modules.

Do not create abstractions for future use.

Do not introduce technical debt by implementing functionality assigned to downstream modules.

Repository Bootstrap only.

Nothing more.

---

# Deliverables

Repository implementation.

Execution history templates.

Repository bootstrap verification.

No additional artifacts.

---

End of Module 01 Coding Prompt.
