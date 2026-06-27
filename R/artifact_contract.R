# artifact_contract.R
#
# Framework Contract: Artifact Contract
#
# Represents the framework-wide Artifact Contract introduced in
# IDS-001_Framework_Implementation.md (named-ancestor requirement,
# single-producer requirement, immutability after handoff, multiplicity
# accommodation, completeness gating). This file implements only the
# reusable contract representation (base R list) and its structural
# validation, construction, predicate, and print behavior -- it does not
# implement any domain-specific artifact (Discovery Candidate, Model
# Candidate, etc.), which remain the responsibility of downstream
# Coding Modules.

#' Create an Artifact Contract
#'
#' Constructs a Framework Artifact Contract following the common
#' Framework Contract schema (`contract_type`, `producer`, `consumer`,
#' `inputs`, `outputs`, `dependencies`, `metadata`). This is a structural
#' contract representation only; it carries no scientific, statistical,
#' or biological content.
#'
#' @param producer Character scalar. Name of the producing domain or
#'   module (single-producer requirement).
#' @param consumer Character scalar. Name of the consuming domain or
#'   module.
#' @param inputs List of contract inputs. Defaults to an empty list.
#' @param outputs List of contract outputs. Defaults to an empty list.
#' @param dependencies List of contract dependencies. Defaults to an
#'   empty list.
#' @param metadata List of contract metadata (e.g. named-ancestor
#'   references). Defaults to an empty list.
#'
#' @return An object of class `c("artifact_contract", "contract")`.
#'
#' @export
create_artifact_contract <- function(producer,
                                      consumer,
                                      inputs = list(),
                                      outputs = list(),
                                      dependencies = list(),
                                      metadata = list()) {

  contract <- .new_contract_fields(
    contract_type = "artifact",
    producer = producer,
    consumer = consumer,
    inputs = inputs,
    outputs = outputs,
    dependencies = dependencies,
    metadata = metadata
  )

  class(contract) <- c("artifact_contract", "contract")

  validate_artifact_contract(contract)

  contract
}

#' Validate an Artifact Contract
#'
#' Verifies required fields, object completeness, and structural
#' consistency of an Artifact Contract. Performs no scientific,
#' statistical, algorithmic, or biological validation.
#'
#' @param x Object to validate.
#'
#' @return Invisibly `TRUE` if `x` is a structurally valid Artifact
#'   Contract; otherwise raises an error via `stop()`.
#'
#' @export
validate_artifact_contract <- function(x) {
  .validate_common_contract_structure(x, contract_type_expected = "artifact")
  invisible(TRUE)
}

#' Test whether an object is an Artifact Contract
#'
#' @param x Object to test.
#'
#' @return `TRUE` if `x` inherits from class `"artifact_contract"`,
#'   `FALSE` otherwise.
#'
#' @export
is_artifact_contract <- function(x) {
  inherits(x, "artifact_contract")
}

#' Print an Artifact Contract
#'
#' @param x An `artifact_contract` object.
#' @param ... Additional arguments (currently unused).
#'
#' @return `x`, invisibly.
#'
#' @export
print.artifact_contract <- function(x, ...) {
  .print_contract_common(x, label = "artifact_contract")
}
