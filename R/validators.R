# validators.R
#
# Internal, shared structural-validation helpers used by all Framework
# Contract validators (validate_artifact_contract, validate_interface_contract,
# validate_dependency_contract, validate_verification_contract).
#
# Per Module 02 Coding Prompt ("Validation"):
#   Validators verify only required fields, object completeness,
#   structural consistency, and contract integrity. Validators do NOT
#   perform scientific, statistical, algorithm, or biological validation,
#   and do not perform runtime benchmarking.
#
# These helpers are internal (not exported) and exist only to avoid
# duplicating the same structural checks across the four contract types.

#' Common Framework Contract schema field names
#'
#' @return A character vector of the field names every Framework Contract
#'   must contain, per the shared contract schema.
#' @keywords internal
#' @noRd
.contract_schema_fields <- function() {
  c("contract_type", "producer", "consumer", "inputs", "outputs",
    "dependencies", "metadata")
}

#' Check that an object is a list containing the required contract fields
#'
#' @param x Object to check.
#' @param contract_type_expected Character scalar; the expected value of
#'   the `contract_type` field.
#' @return Invisibly `TRUE` if structurally valid; otherwise calls `stop()`
#'   with an informative message.
#' @keywords internal
#' @noRd
.validate_common_contract_structure <- function(x, contract_type_expected) {

  if (!is.list(x)) {
    stop("Contract must be a list. Received object of class: ",
         paste(class(x), collapse = ", "), call. = FALSE)
  }

  required_fields <- .contract_schema_fields()
  missing_fields <- setdiff(required_fields, names(x))

  if (length(missing_fields) > 0) {
    stop("Contract is missing required field(s): ",
         paste(missing_fields, collapse = ", "), call. = FALSE)
  }

  if (!is.character(x$contract_type) || length(x$contract_type) != 1) {
    stop("Contract field 'contract_type' must be a single character string.",
         call. = FALSE)
  }

  if (!identical(x$contract_type, contract_type_expected)) {
    stop("Contract field 'contract_type' must equal '", contract_type_expected,
         "'. Received: '", x$contract_type, "'.", call. = FALSE)
  }

  if (!is.character(x$producer) || length(x$producer) != 1 || !nzchar(x$producer)) {
    stop("Contract field 'producer' must be a single non-empty character string.",
         call. = FALSE)
  }

  if (!is.character(x$consumer) || length(x$consumer) != 1 || !nzchar(x$consumer)) {
    stop("Contract field 'consumer' must be a single non-empty character string.",
         call. = FALSE)
  }

  for (field in c("inputs", "outputs", "dependencies", "metadata")) {
    if (!is.list(x[[field]])) {
      stop("Contract field '", field, "' must be a list.", call. = FALSE)
    }
  }

  invisible(TRUE)
}

#' Construct the common Framework Contract field list
#'
#' @param contract_type Character scalar identifying the contract type.
#' @param producer Character scalar naming the producing domain/module.
#' @param consumer Character scalar naming the consuming domain/module.
#' @param inputs List of contract inputs.
#' @param outputs List of contract outputs.
#' @param dependencies List of contract dependencies.
#' @param metadata List of contract metadata.
#' @return A base list following the common Framework Contract schema.
#' @keywords internal
#' @noRd
.new_contract_fields <- function(contract_type, producer, consumer,
                                  inputs, outputs, dependencies, metadata) {
  list(
    contract_type = contract_type,
    producer = producer,
    consumer = consumer,
    inputs = inputs,
    outputs = outputs,
    dependencies = dependencies,
    metadata = metadata
  )
}

#' Print the common fields shared by all Framework Contracts
#'
#' @param x A Framework Contract object.
#' @param label Character scalar; the human-readable contract type label
#'   to display in the header line.
#' @return `x`, invisibly.
#' @keywords internal
#' @noRd
.print_contract_common <- function(x, label) {
  cat("<", label, ">\n", sep = "")
  cat("  producer:     ", x$producer, "\n", sep = "")
  cat("  consumer:     ", x$consumer, "\n", sep = "")
  cat("  inputs:       ", length(x$inputs), " item(s)\n", sep = "")
  cat("  outputs:      ", length(x$outputs), " item(s)\n", sep = "")
  cat("  dependencies: ", length(x$dependencies), " item(s)\n", sep = "")
  cat("  metadata:     ", length(x$metadata), " item(s)\n", sep = "")
  invisible(x)
}
