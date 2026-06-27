# dependency_contract.R
#
# Framework Contract: Dependency Contract
#
# Represents the framework-wide Dependency Contract introduced in
# IDS-001_Framework_Implementation.md (sequential dependency by
# default; no circular dependency; dependency on contracts only, never
# on implementation details, runtime state, execution environment, or
# undocumented side effects; cross-domain sequencing reserved for
# IMPLEMENTATION_MASTER_PLAN.md). This file implements only the
# reusable contract representation and its structural validation,
# construction, predicate, and print behavior.

#' Create a Dependency Contract
#'
#' Constructs a Framework Dependency Contract following the common
#' Framework Contract schema. Represents a contractual dependency of a
#' consuming domain on a producing domain's contracted artifacts. This
#' is a structural contract representation only.
#'
#' @param producer Character scalar. Name of the domain or module being
#'   depended upon.
#' @param consumer Character scalar. Name of the domain or module that
#'   holds the dependency.
#' @param inputs List of contract inputs. Defaults to an empty list.
#' @param outputs List of contract outputs. Defaults to an empty list.
#' @param dependencies List of contract dependencies (e.g. named
#'   references to upstream contracts). Defaults to an empty list.
#' @param metadata List of contract metadata. Defaults to an empty list.
#'
#' @return An object of class `c("dependency_contract", "contract")`.
#'
#' @export
create_dependency_contract <- function(producer,
                                        consumer,
                                        inputs = list(),
                                        outputs = list(),
                                        dependencies = list(),
                                        metadata = list()) {

  contract <- .new_contract_fields(
    contract_type = "dependency",
    producer = producer,
    consumer = consumer,
    inputs = inputs,
    outputs = outputs,
    dependencies = dependencies,
    metadata = metadata
  )

  class(contract) <- c("dependency_contract", "contract")

  validate_dependency_contract(contract)

  contract
}

#' Validate a Dependency Contract
#'
#' Verifies required fields, object completeness, and structural
#' consistency of a Dependency Contract. Performs no scientific,
#' statistical, algorithmic, or biological validation.
#'
#' @param x Object to validate.
#'
#' @return Invisibly `TRUE` if `x` is a structurally valid Dependency
#'   Contract; otherwise raises an error via `stop()`.
#'
#' @export
validate_dependency_contract <- function(x) {
  .validate_common_contract_structure(x, contract_type_expected = "dependency")
  invisible(TRUE)
}

#' Test whether an object is a Dependency Contract
#'
#' @param x Object to test.
#'
#' @return `TRUE` if `x` inherits from class `"dependency_contract"`,
#'   `FALSE` otherwise.
#'
#' @export
is_dependency_contract <- function(x) {
  inherits(x, "dependency_contract")
}

#' Print a Dependency Contract
#'
#' @param x A `dependency_contract` object.
#' @param ... Additional arguments (currently unused).
#'
#' @return `x`, invisibly.
#'
#' @export
print.dependency_contract <- function(x, ...) {
  .print_contract_common(x, label = "dependency_contract")
}
