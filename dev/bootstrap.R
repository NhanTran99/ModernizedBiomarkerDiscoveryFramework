## dev/bootstrap.R
##
## Module 01 — Repository Bootstrap
##
## This script is run ONCE, locally, by the Project Coordinator in R,
## to complete the steps of repository bootstrap that require live
## execution (renv lockfile generation, roxygen2/NAMESPACE generation,
## and a local package-load + test verification).
##
## Per governance (CODING_PHASE_PHILOSOPHY.md, PROJECT_GOVERNANCE_PROMPT_v4.6):
## official execution is always local R by the Project Coordinator.
## This script performs no framework, algorithmic, or scientific logic
## — Repository Bootstrap only.
##
## Run from the repository root:
##   source("dev/bootstrap.R")

## ---- 0. Pre-flight ----------------------------------------------------
stopifnot(basename(getwd()) == "GCSignatureFramework")

if (!requireNamespace("renv", quietly = TRUE)) install.packages("renv")
if (!requireNamespace("roxygen2", quietly = TRUE)) install.packages("roxygen2")
if (!requireNamespace("testthat", quietly = TRUE)) install.packages("testthat")
if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")

## ---- 1. Initialize renv (reproducible environment) --------------------
## Creates renv.lock, renv/activate.R, and project-local library.
if (!file.exists("renv.lock")) {
  renv::init(bare = TRUE)
}
renv::snapshot(prompt = FALSE)

## ---- 2. Generate NAMESPACE and man/ via roxygen2 -----------------------
## NAMESPACE and Rd documentation are never hand-maintained (see
## Coding Prompt, "roxygen2" section). Safe to run even with an empty
## R/ directory.
roxygen2::roxygenise()

## ---- 3. Verify the package loads -----------------------------------
devtools::load_all(quiet = FALSE)

## ---- 4. Run the bootstrap-only test suite -----------------------------
## Only the Module 01 smoke test (test-bootstrap.R) should exist at
## this stage. No algorithmic, framework, or scientific tests are
## expected or permitted yet.
testthat::test_dir("tests/testthat", reporter = "summary")

## ---- 5. Report ----------------------------------------------------
message("Module 01 — Repository Bootstrap: local verification complete.")
message("Record results in Execution/Module_01/Execution_Log.md")
