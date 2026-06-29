# interpretation.R
#
# Scientific Interpretation (Module 12, IDS-005)
#
# Implements the Scientific Interpretation responsibility of IDS-005:
# read-only consumption of Validated Candidate (Module 11), an
# Interpretation Object (implementation-only, never a Framework
# artifact) capturing the consumed candidate + execution state, and
# Interpretation Evidence (the sole Framework artifact produced by
# this module). Contains no pathway analysis, enrichment analysis,
# explainability algorithms (SHAP, feature importance), biological
# reasoning, or scientific interpretation methodology -- those
# responsibilities are explicitly outside Module 12, and Evidence
# Integration / Interpretation Package construction belong to
# Module 13.
#
# Per the Coding Prompt's Consistency Check: Interpretation Evidence
# uses metadata$framework_layer = "interpretability" (the first
# IDS-005 layer name) and metadata$artifact_role = "interpretation_evidence".
# Default consumer is "interpretation_package" (Module 13).
#
# Per the Generic Implementation Principle: the default interpreter
# performs only structural execution -- no pathway/enrichment
# analysis, SHAP, feature importance, or biological reasoning. Real
# interpretation methodology remains injectable via the `interpreter`
# callback (mirroring Module 07's `trainer`, Module 09's `validator`,
# Module 10's `benchmarker`, and Module 11's `selector`).

# ---- Interpretation Object (implementation-only) ----------------------------

#' Create an Interpretation Object
#'
#' Constructs an Interpretation Object: an implementation-only object
#' (never exposed as a Framework artifact) that encapsulates the
#' consumed Validated Candidate (Module 11), interpretation components,
#' execution metadata, and implementation state. Validated Candidate is
#' consumed completely read-only and is never modified by this function
#' or by [run_interpretation()].
#'
#' Only a `validated_candidate` object is accepted as the upstream
#' contract; this module never directly consumes Validation Evidence
#' or Benchmark Evidence -- those remain available, if needed, only
#' through the lineage already preserved within the Validated
#' Candidate.
#'
#' @param validated_candidate A `validated_candidate` object (Module 11).
#' @param metadata List of additional implementation metadata.
#'   Defaults to an empty list.
#'
#' @return An object of class `"interpretation_object"`, with fields
#'   `validated_candidate`, `interpretation_components` (initially an
#'   empty list), `execution_metadata` (initially an empty list), and
#'   `metadata`.
#'
#' @export
create_interpretation_object <- function(validated_candidate, metadata = list()) {

  if (!inherits(validated_candidate, "validated_candidate")) {
    stop("'validated_candidate' must be a validated_candidate object (Module 11).",
         call. = FALSE)
  }
  validate_validated_candidate(validated_candidate)

  if (!is.list(metadata)) {
    stop("'metadata' must be a list.", call. = FALSE)
  }

  interpretation_object <- list(
    validated_candidate = validated_candidate,
    interpretation_components = list(),
    execution_metadata = list(),
    metadata = metadata
  )

  class(interpretation_object) <- "interpretation_object"

  interpretation_object
}

#' Validate an Interpretation Object
#'
#' Verifies required fields, object completeness, and structural
#' consistency of an Interpretation Object, including delegated
#' structural validity of its embedded Validated Candidate (via the
#' LOCKED Module 11 `validate_validated_candidate()`). Performs no
#' scientific, statistical, or biological validation.
#'
#' @param x Object to validate.
#'
#' @return Invisibly `TRUE` if `x` is a structurally valid
#'   Interpretation Object; otherwise raises an error via `stop()`.
#'
#' @export
validate_interpretation_object <- function(x) {

  if (!.is_interpretation_object(x)) {
    stop("'x' must be an interpretation_object object.", call. = FALSE)
  }

  required_fields <- c("validated_candidate", "interpretation_components",
                        "execution_metadata", "metadata")
  missing_fields <- setdiff(required_fields, names(x))
  if (length(missing_fields) > 0) {
    stop("Interpretation Object is missing required field(s): ",
         paste(missing_fields, collapse = ", "), call. = FALSE)
  }

  validate_validated_candidate(x$validated_candidate)

  if (!is.list(x$interpretation_components)) {
    stop("Interpretation Object field 'interpretation_components' must be a list.", call. = FALSE)
  }
  if (!is.list(x$execution_metadata)) {
    stop("Interpretation Object field 'execution_metadata' must be a list.", call. = FALSE)
  }
  if (!is.list(x$metadata)) {
    stop("Interpretation Object field 'metadata' must be a list.", call. = FALSE)
  }

  invisible(TRUE)
}

#' @keywords internal
#' @noRd
.is_interpretation_object <- function(x) {
  inherits(x, "interpretation_object")
}

#' Print an Interpretation Object
#'
#' @param x An `interpretation_object` object.
#' @param ... Additional arguments (currently unused).
#'
#' @return `x`, invisibly.
#'
#' @export
print.interpretation_object <- function(x, ...) {
  cat("<interpretation_object>\n")
  cat("  validated_candidate:        embedded (producer: ", x$validated_candidate$producer, ")\n", sep = "")
  cat("  interpretation_components:  ", length(x$interpretation_components), " component(s)\n", sep = "")
  cat("  execution_metadata:         ", length(x$execution_metadata), " item(s)\n", sep = "")
  invisible(x)
}

# ---- Default generic interpreter (no real methodology) ---------------------

#' @keywords internal
#' @noRd
.default_generic_interpreter <- function(interpretation_object, ...) {
  list(
    structural_check = list(
      passed = TRUE,
      details = "generic structural check only; no pathway/enrichment/SHAP/feature-importance/biological methodology"
    )
  )
}

# ---- Interpretation Workflow / Executor -------------------------------------

#' Run Interpretation (Workflow + Executor)
#'
#' Orchestrates the Interpretation workflow for an initial
#' Interpretation Object: invokes an interpreter (the default generic
#' interpreter, or a caller-supplied one) to produce one or more named
#' `interpretation_components`, returns an updated Interpretation
#' Object carrying those components, and constructs the resulting
#' Interpretation Evidence -- mirroring Module 09's `run_validation()`,
#' Module 10's `run_benchmark()`, and Module 11's `run_candidate_selection()`.
#'
#' The interpreter replaces only the execution step; it never bypasses
#' workflow, verification, lineage, or artifact construction performed
#' by this function. The default interpreter performs only a generic,
#' structural check -- no pathway analysis, enrichment analysis,
#' explainability algorithms (SHAP, feature importance), or biological
#' reasoning is performed by this function or its default interpreter.
#'
#' @param interpretation_object An `interpretation_object`, as returned
#'   by [create_interpretation_object()].
#' @param interpreter A function taking `(interpretation_object, ...)`
#'   and returning a named list of interpretation components. Defaults
#'   to an internal generic, structural placeholder interpreter.
#' @param ... Additional arguments forwarded to `interpreter`.
#'
#' @return A list with elements `interpretation_object` (the updated
#'   object, with `interpretation_components` populated) and
#'   `interpretation_evidence` (the resulting Framework artifact).
#'
#' @export
run_interpretation <- function(interpretation_object, interpreter = NULL, ...) {

  validate_interpretation_object(interpretation_object)

  if (is.null(interpreter)) {
    interpreter <- .default_generic_interpreter
  }
  if (!is.function(interpreter)) {
    stop("'interpreter' must be a function.", call. = FALSE)
  }

  components <- interpreter(interpretation_object, ...)

  if (!is.list(components)) {
    stop("'interpreter' must return a list of named interpretation components.", call. = FALSE)
  }

  updated <- interpretation_object
  updated$interpretation_components <- components
  updated$execution_metadata <- c(updated$execution_metadata, list(executed = TRUE))

  validate_interpretation_object(updated)

  evidence <- create_interpretation_evidence(updated)

  list(
    interpretation_object = updated,
    interpretation_evidence = evidence
  )
}

# ---- Interpretation Evidence (the sole Framework artifact) -----------------

#' Create Interpretation Evidence
#'
#' Constructs Interpretation Evidence: the sole Framework artifact
#' produced by Module 12 (via the LOCKED Module 02
#' `create_artifact_contract()`), structurally independent from the
#' supplied Interpretation Object while preserving complete lineage by
#' embedding it unchanged. Interpretation Evidence never contains
#' Evidence Integration, Interpretation Package, Clinical Translation,
#' or publication-ready interpretation.
#'
#' @param interpretation_object An `interpretation_object`, typically
#'   the updated object produced by [run_interpretation()].
#' @param producer Character scalar identifying the producer. Defaults
#'   to the embedded Validated Candidate's `producer`.
#' @param consumer Character scalar identifying the intended downstream
#'   consumer. Defaults to `"interpretation_package"` (Module 13,
#'   IDS-005).
#' @param metadata Additional list of metadata merged into the
#'   artifact's `metadata` field. Defaults to an empty list. Must not
#'   contain `framework_layer`, `artifact_role`, or
#'   `interpretation_object` (set internally), nor `evidence_integration`,
#'   `interpretation_package`, `clinical_translation`, or
#'   `publication_ready_interpretation` (explicitly forbidden content).
#'
#' @return An object of class `c("interpretation_evidence", "artifact_contract", "contract")`.
#'
#' @export
create_interpretation_evidence <- function(interpretation_object,
                                            producer = NULL,
                                            consumer = "interpretation_package",
                                            metadata = list()) {

  validate_interpretation_object(interpretation_object)

  if (!is.list(metadata)) {
    stop("'metadata' must be a list.", call. = FALSE)
  }

  reserved <- intersect(names(metadata),
                         c("framework_layer", "artifact_role", "interpretation_object"))
  if (length(reserved) > 0) {
    stop("'metadata' must not contain reserved key(s): ",
         paste(reserved, collapse = ", "), call. = FALSE)
  }

  forbidden <- intersect(names(metadata),
                          c("evidence_integration", "interpretation_package",
                            "clinical_translation", "publication_ready_interpretation"))
  if (length(forbidden) > 0) {
    stop("Interpretation Evidence SHALL NOT contain: ",
         paste(forbidden, collapse = ", "), call. = FALSE)
  }

  if (is.null(producer)) {
    producer <- interpretation_object$validated_candidate$producer
  }

  full_metadata <- c(
    list(
      framework_layer = "interpretability",
      artifact_role = "interpretation_evidence",
      interpretation_object = interpretation_object
    ),
    metadata
  )

  evidence <- create_artifact_contract(
    producer = producer,
    consumer = consumer,
    inputs = list("validated_candidate"),
    outputs = list("interpretation_evidence"),
    dependencies = list(),
    metadata = full_metadata
  )

  class(evidence) <- c("interpretation_evidence", class(evidence))

  evidence
}

#' Validate Interpretation Evidence
#'
#' Verifies required fields, contract validity (via the LOCKED Module
#' 02 `validate_artifact_contract()`), and lineage integrity of
#' Interpretation Evidence. Confirms the forbidden-content guarantee
#' (no Evidence Integration, Interpretation Package, Clinical
#' Translation, or publication-ready interpretation). Performs no
#' scientific, statistical, or biological validation.
#'
#' @param x Object to validate.
#'
#' @return Invisibly `TRUE` if `x` is structurally valid; otherwise
#'   raises an error via `stop()`.
#'
#' @export
validate_interpretation_evidence <- function(x) {

  if (!inherits(x, "interpretation_evidence")) {
    stop("'x' must be an interpretation_evidence object.", call. = FALSE)
  }

  if (!is_artifact_contract(x)) {
    stop("'x' must be an artifact_contract object (Module 02).", call. = FALSE)
  }

  validate_artifact_contract(x)

  if (!identical(x$contract_type, "artifact")) {
    stop("Interpretation Evidence field 'contract_type' must equal 'artifact'. ",
         "Received: '", x$contract_type, "'.", call. = FALSE)
  }

  if (!identical(x$metadata$artifact_role, "interpretation_evidence")) {
    stop("Interpretation Evidence must have metadata$artifact_role == 'interpretation_evidence'.",
         call. = FALSE)
  }

  if (is.null(x$metadata$interpretation_object)) {
    stop("Interpretation Evidence is missing its embedded interpretation_object ",
         "(lineage integrity).", call. = FALSE)
  }
  validate_interpretation_object(x$metadata$interpretation_object)

  forbidden_present <- intersect(names(x$metadata),
                                  c("evidence_integration", "interpretation_package",
                                    "clinical_translation", "publication_ready_interpretation"))
  if (length(forbidden_present) > 0) {
    stop("Interpretation Evidence must not contain: ",
         paste(forbidden_present, collapse = ", "), call. = FALSE)
  }

  invisible(TRUE)
}

#' Print Interpretation Evidence
#'
#' @param x An `interpretation_evidence` object.
#' @param ... Additional arguments (currently unused).
#'
#' @return `x`, invisibly.
#'
#' @export
print.interpretation_evidence <- function(x, ...) {
  cat("<interpretation_evidence>\n")
  cat("  producer:                   ", x$producer, "\n", sep = "")
  cat("  consumer:                   ", x$consumer, "\n", sep = "")
  components <- x$metadata$interpretation_object$interpretation_components
  cat("  interpretation_components:  ",
      if (length(components) > 0) paste(names(components), collapse = ", ") else "(none yet)",
      "\n", sep = "")
  cat("  interpretation_object:      embedded (lineage preserved)\n", sep = "")
  invisible(x)
}
