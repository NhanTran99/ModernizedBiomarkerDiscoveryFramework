# interface_contract.R
#
# Framework Contract: Interface Contract
#
# Represents the framework-wide Interface Contract introduced in
# IDS-001_Framework_Implementation.md (one contracted interface per
# domain pair; jointly defined by producing and consuming domains but
# owned and formally specified by the consuming domain's IDS; no
# side-channel passage; directionality fixed by FRAMEWORK_SPEC;
# interface stability; explicit non-interfaces between non-adjacent
# domains). This file implements only the reusable contract
# representation and its structural validation, construction,
# predicate, and print behavior.

#' Create an Interface Contract
#'
#' Constructs a Framework Interface Contract following the common
#' Framework Contract schema. Represents the contracted interface
#' between a producing domain and a consuming domain. This is a
#' structural contract representation only.
#'
#' @param producer Character scalar. Name of the producing domain or
#'   module.
#' @param consumer Character scalar. Name of the consuming domain or
#'   module.
#' @param inputs List of contract inputs. Defaults to an empty list.
#' @param outputs List of contract outputs. Defaults to an empty list.
#' @param dependencies List of contract dependencies. Defaults to an
#'   empty list.
#' @param metadata List of contract metadata. Defaults to an empty list.
#'
#' @return An object of class `c("interface_contract", "contract")`.
#'
#' @export
create_interface_contract <- function(producer,
                                       consumer,
                                       inputs = list(),
                                       outputs = list(),
                                       dependencies = list(),
                                       metadata = list()) {

  contract <- .new_contract_fields(
    contract_type = "interface",
    producer = producer,
    consumer = consumer,
    inputs = inputs,
    outputs = outputs,
    dependencies = dependencies,
    metadata = metadata
  )

  class(contract) <- c("interface_contract", "contract")

  validate_interface_contract(contract)

  contract
}

#' Validate an Interface Contract
#'
#' Verifies required fields, object completeness, and structural
#' consistency of an Interface Contract. Performs no scientific,
#' statistical, algorithmic, or biological validation.
#'
#' @param x Object to validate.
#'
#' @return Invisibly `TRUE` if `x` is a structurally valid Interface
#'   Contract; otherwise raises an error via `stop()`.
#'
#' @export
validate_interface_contract <- function(x) {
  .validate_common_contract_structure(x, contract_type_expected = "interface")
  invisible(TRUE)
}

#' Test whether an object is an Interface Contract
#'
#' @param x Object to test.
#'
#' @return `TRUE` if `x` inherits from class `"interface_contract"`,
#'   `FALSE` otherwise.
#'
#' @export
is_interface_contract <- function(x) {
  inherits(x, "interface_contract")
}

#' Print an Interface Contract
#'
#' @param x An `interface_contract` object.
#' @param ... Additional arguments (currently unused).
#'
#' @return `x`, invisibly.
#'
#' @export
print.interface_contract <- function(x, ...) {
  .print_contract_common(x, label = "interface_contract")
}
