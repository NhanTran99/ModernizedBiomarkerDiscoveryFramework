# candidate_selection.R
#
# Candidate Selection (Module 11, IDS-004)
#
# Implements the Candidate Selection responsibility of IDS-004:
# read-only consumption of Benchmark Evidence (Module 10), a Candidate
# Selection Object (implementation-only, never a Framework artifact)
# capturing the consumed evidence + execution state, and Validated
# Candidate (the sole, final Framework artifact produced by IDS-004).
# Contains no ranking, score optimization, statistical comparison,
# biological interpretation, clinical recommendation, or machine
# learning methodology -- those responsibilities are explicitly
# outside Module 11 and IDS-004 entirely.
#
# Per the Coding Prompt's Consistency Check: Validated Candidate uses
# metadata$framework_layer = "validation_benchmark" (same layer as
# Validation Evidence and Benchmark Evidence) and metadata$artifact_role
# = "validated_candidate" -- completing the four-value artifact_role
# set anticipated since Module 09. Default consumer is "interpretability"
# (Phase E, Modules 12-13).
#
# Per the Generic Implementation Principle: the default selector
# performs only structural execution -- no ranking, score optimization,
# statistical comparison, biological interpretation, clinical
# recommendation, or ML methodology. Real selection methodology remains
# injectable via the `selector` callback (mirroring Module 07's
# `trainer`, Module 09's `validator`, and Module 10's `benchmarker`).

# ---- Candidate Selection Object (implementation-only) -----------------------

#' Create a Candidate Selection Object
#'
#' Constructs a Candidate Selection Object: an implementation-only
#' object (never exposed as a Framework artifact) that encapsulates
#' the consumed Benchmark Evidence (Module 10), selection components,
#' execution metadata, and implementation state. Benchmark Evidence is
#' consumed completely read-only and is never modified by this
#' function or by [run_candidate_selection()].
#'
#' @param benchmark_evidence A `benchmark_evidence` object (Module 10).
#' @param metadata List of additional implementation metadata.
#'   Defaults to an empty list.
#'
#' @return An object of class `"candidate_selection_object"`, with
#'   fields `benchmark_evidence`, `selection_components` (initially an
#'   empty list), `execution_metadata` (initially an empty list), and
#'   `metadata`.
#'
#' @export
create_candidate_selection_object <- function(benchmark_evidence, metadata = list()) {

  if (!inherits(benchmark_evidence, "benchmark_evidence")) {
    stop("'benchmark_evidence' must be a benchmark_evidence object (Module 10).",
         call. = FALSE)
  }
  validate_benchmark_evidence(benchmark_evidence)

  if (!is.list(metadata)) {
    stop("'metadata' must be a list.", call. = FALSE)
  }

  candidate_selection_object <- list(
    benchmark_evidence = benchmark_evidence,
    selection_components = list(),
    execution_metadata = list(),
    metadata = metadata
  )

  class(candidate_selection_object) <- "candidate_selection_object"

  candidate_selection_object
}

#' Validate a Candidate Selection Object
#'
#' Verifies required fields, object completeness, and structural
#' consistency of a Candidate Selection Object, including delegated
#' structural validity of its embedded Benchmark Evidence (via the
#' LOCKED Module 10 `validate_benchmark_evidence()`). Performs no
#' scientific, statistical, ranking, or biological validation.
#'
#' @param x Object to validate.
#'
#' @return Invisibly `TRUE` if `x` is a structurally valid Candidate
#'   Selection Object; otherwise raises an error via `stop()`.
#'
#' @export
validate_candidate_selection_object <- function(x) {

  if (!.is_candidate_selection_object(x)) {
    stop("'x' must be a candidate_selection_object object.", call. = FALSE)
  }

  required_fields <- c("benchmark_evidence", "selection_components", "execution_metadata", "metadata")
  missing_fields <- setdiff(required_fields, names(x))
  if (length(missing_fields) > 0) {
    stop("Candidate Selection Object is missing required field(s): ",
         paste(missing_fields, collapse = ", "), call. = FALSE)
  }

  validate_benchmark_evidence(x$benchmark_evidence)

  if (!is.list(x$selection_components)) {
    stop("Candidate Selection Object field 'selection_components' must be a list.", call. = FALSE)
  }
  if (!is.list(x$execution_metadata)) {
    stop("Candidate Selection Object field 'execution_metadata' must be a list.", call. = FALSE)
  }
  if (!is.list(x$metadata)) {
    stop("Candidate Selection Object field 'metadata' must be a list.", call. = FALSE)
  }

  invisible(TRUE)
}

#' @keywords internal
#' @noRd
.is_candidate_selection_object <- function(x) {
  inherits(x, "candidate_selection_object")
}

#' Print a Candidate Selection Object
#'
#' @param x A `candidate_selection_object` object.
#' @param ... Additional arguments (currently unused).
#'
#' @return `x`, invisibly.
#'
#' @export
print.candidate_selection_object <- function(x, ...) {
  cat("<candidate_selection_object>\n")
  cat("  benchmark_evidence:    embedded (producer: ", x$benchmark_evidence$producer, ")\n", sep = "")
  cat("  selection_components:  ", length(x$selection_components), " component(s)\n", sep = "")
  cat("  execution_metadata:    ", length(x$execution_metadata), " item(s)\n", sep = "")
  invisible(x)
}

# ---- Default generic selector (no real methodology) ------------------------

#' @keywords internal
#' @noRd
.default_generic_selector <- function(candidate_selection_object, ...) {
  list(
    structural_check = list(
      passed = TRUE,
      details = "generic structural check only; no ranking/score-optimization/statistical/biological/ML methodology"
    )
  )
}

# ---- Candidate Selection Workflow / Executor --------------------------------

#' Run Candidate Selection (Workflow + Executor)
#'
#' Orchestrates the Candidate Selection workflow for an initial
#' Candidate Selection Object: invokes a selector (the default generic
#' selector, or a caller-supplied one) to produce one or more named
#' `selection_components`, returns an updated Candidate Selection
#' Object carrying those components, and constructs the resulting
#' Validated Candidate -- mirroring Module 09's `run_validation()` and
#' Module 10's `run_benchmark()`.
#'
#' The selector replaces only the execution step; it never bypasses
#' workflow, verification, lineage, or artifact construction performed
#' by this function. The default selector performs only a generic,
#' structural check -- no ranking, score optimization, statistical
#' comparison, biological interpretation, clinical recommendation, or
#' machine learning methodology is performed by this function or its
#' default selector.
#'
#' @param candidate_selection_object A `candidate_selection_object`, as
#'   returned by [create_candidate_selection_object()].
#' @param selector A function taking `(candidate_selection_object, ...)`
#'   and returning a named list of selection components. Defaults to
#'   an internal generic, structural placeholder selector.
#' @param ... Additional arguments forwarded to `selector`.
#'
#' @return A list with elements `candidate_selection_object` (the
#'   updated object, with `selection_components` populated) and
#'   `validated_candidate` (the resulting, final Framework artifact of
#'   IDS-004).
#'
#' @export
run_candidate_selection <- function(candidate_selection_object, selector = NULL, ...) {

  validate_candidate_selection_object(candidate_selection_object)

  if (is.null(selector)) {
    selector <- .default_generic_selector
  }
  if (!is.function(selector)) {
    stop("'selector' must be a function.", call. = FALSE)
  }

  components <- selector(candidate_selection_object, ...)

  if (!is.list(components)) {
    stop("'selector' must return a list of named selection components.", call. = FALSE)
  }

  updated <- candidate_selection_object
  updated$selection_components <- components
  updated$execution_metadata <- c(updated$execution_metadata, list(executed = TRUE))

  validate_candidate_selection_object(updated)

  candidate <- create_validated_candidate(updated)

  list(
    candidate_selection_object = updated,
    validated_candidate = candidate
  )
}

# ---- Validated Candidate (the sole, final Framework artifact of IDS-004) ----

#' Create a Validated Candidate
#'
#' Constructs Validated Candidate: the sole Framework artifact produced
#' by Module 11 (via the LOCKED Module 02 `create_artifact_contract()`),
#' and the final Framework artifact produced by IDS-004. Structurally
#' independent from the supplied Candidate Selection Object while
#' preserving complete lineage by embedding it unchanged. Validated
#' Candidate never contains scientific interpretation, biological
#' recommendation, clinical recommendation, publication-ready
#' conclusions, or therapeutic recommendations.
#'
#' @param candidate_selection_object A `candidate_selection_object`,
#'   typically the updated object produced by [run_candidate_selection()].
#' @param producer Character scalar identifying the producer. Defaults
#'   to the embedded Benchmark Evidence's `producer`.
#' @param consumer Character scalar identifying the intended downstream
#'   consumer. Defaults to `"interpretability"` (Phase E, Modules 12-13).
#' @param metadata Additional list of metadata merged into the
#'   artifact's `metadata` field. Defaults to an empty list. Must not
#'   contain `framework_layer`, `artifact_role`, or
#'   `candidate_selection_object` (set internally), nor
#'   `scientific_interpretation`, `biological_recommendation`,
#'   `clinical_recommendation`, `publication_ready_conclusions`, or
#'   `therapeutic_recommendations` (explicitly forbidden content).
#'
#' @return An object of class `c("validated_candidate", "artifact_contract", "contract")`.
#'
#' @export
create_validated_candidate <- function(candidate_selection_object,
                                        producer = NULL,
                                        consumer = "interpretability",
                                        metadata = list()) {

  validate_candidate_selection_object(candidate_selection_object)

  if (!is.list(metadata)) {
    stop("'metadata' must be a list.", call. = FALSE)
  }

  reserved <- intersect(names(metadata),
                         c("framework_layer", "artifact_role", "candidate_selection_object"))
  if (length(reserved) > 0) {
    stop("'metadata' must not contain reserved key(s): ",
         paste(reserved, collapse = ", "), call. = FALSE)
  }

  forbidden <- intersect(names(metadata),
                          c("scientific_interpretation", "biological_recommendation",
                            "clinical_recommendation", "publication_ready_conclusions",
                            "therapeutic_recommendations"))
  if (length(forbidden) > 0) {
    stop("Validated Candidate SHALL NOT contain: ",
         paste(forbidden, collapse = ", "), call. = FALSE)
  }

  if (is.null(producer)) {
    producer <- candidate_selection_object$benchmark_evidence$producer
  }

  full_metadata <- c(
    list(
      framework_layer = "validation_benchmark",
      artifact_role = "validated_candidate",
      candidate_selection_object = candidate_selection_object
    ),
    metadata
  )

  candidate <- create_artifact_contract(
    producer = producer,
    consumer = consumer,
    inputs = list("benchmark_evidence"),
    outputs = list("validated_candidate"),
    dependencies = list(),
    metadata = full_metadata
  )

  class(candidate) <- c("validated_candidate", class(candidate))

  candidate
}

#' Validate a Validated Candidate
#'
#' Verifies required fields, contract validity (via the LOCKED Module
#' 02 `validate_artifact_contract()`), and lineage integrity of
#' Validated Candidate. Confirms the forbidden-content guarantee (no
#' scientific interpretation, biological recommendation, clinical
#' recommendation, publication-ready conclusions, or therapeutic
#' recommendations). Performs no scientific, statistical, or
#' biological validation.
#'
#' @param x Object to validate.
#'
#' @return Invisibly `TRUE` if `x` is structurally valid; otherwise
#'   raises an error via `stop()`.
#'
#' @export
validate_validated_candidate <- function(x) {

  if (!inherits(x, "validated_candidate")) {
    stop("'x' must be a validated_candidate object.", call. = FALSE)
  }

  if (!is_artifact_contract(x)) {
    stop("'x' must be an artifact_contract object (Module 02).", call. = FALSE)
  }

  validate_artifact_contract(x)

  if (!identical(x$contract_type, "artifact")) {
    stop("Validated Candidate field 'contract_type' must equal 'artifact'. ",
         "Received: '", x$contract_type, "'.", call. = FALSE)
  }

  if (!identical(x$metadata$artifact_role, "validated_candidate")) {
    stop("Validated Candidate must have metadata$artifact_role == 'validated_candidate'.",
         call. = FALSE)
  }

  if (is.null(x$metadata$candidate_selection_object)) {
    stop("Validated Candidate is missing its embedded candidate_selection_object ",
         "(lineage integrity).", call. = FALSE)
  }
  validate_candidate_selection_object(x$metadata$candidate_selection_object)

  forbidden_present <- intersect(names(x$metadata),
                                  c("scientific_interpretation", "biological_recommendation",
                                    "clinical_recommendation", "publication_ready_conclusions",
                                    "therapeutic_recommendations"))
  if (length(forbidden_present) > 0) {
    stop("Validated Candidate must not contain: ",
         paste(forbidden_present, collapse = ", "), call. = FALSE)
  }

  invisible(TRUE)
}

#' Print a Validated Candidate
#'
#' @param x A `validated_candidate` object.
#' @param ... Additional arguments (currently unused).
#'
#' @return `x`, invisibly.
#'
#' @export
print.validated_candidate <- function(x, ...) {
  cat("<validated_candidate>\n")
  cat("  producer:               ", x$producer, "\n", sep = "")
  cat("  consumer:               ", x$consumer, "\n", sep = "")
  components <- x$metadata$candidate_selection_object$selection_components
  cat("  selection_components:   ",
      if (length(components) > 0) paste(names(components), collapse = ", ") else "(none yet)",
      "\n", sep = "")
  cat("  candidate_selection_object: embedded (lineage preserved)\n", sep = "")
  invisible(x)
}
