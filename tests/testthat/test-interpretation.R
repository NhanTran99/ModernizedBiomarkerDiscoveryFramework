# ---- Test fixtures -------------------------------------------------------

valid_discovery_artifact <- function() {
  create_artifact_contract(
    producer = "discovery_pipeline",
    consumer = "modeling_pipeline",
    outputs = list("processed_dataset"),
    metadata = list(framework_layer = "processing")
  )
}

valid_training_object <- function() {
  spec <- create_model_specification(
    algorithm_id = "placeholder_algorithm",
    parameter_schema = list(param_a = "numeric")
  )
  contract <- create_model_contract(spec, valid_discovery_artifact())
  mo <- create_model_object(spec, contract)
  create_training_object(train_model(mo), mo)
}

valid_validated_candidate <- function() {
  output <- create_model_output(valid_training_object())
  vo <- create_validation_object(output$model_candidate, output$modeling_evidence)
  validation_result <- run_validation(vo)
  bo <- create_benchmark_object(validation_result$validation_evidence)
  benchmark_result <- run_benchmark(bo)
  cso <- create_candidate_selection_object(benchmark_result$benchmark_evidence)
  run_candidate_selection(cso)$validated_candidate
}

valid_interpretation_object <- function() {
  create_interpretation_object(valid_validated_candidate())
}

# ---- Interpretation Object construction --------------------------------------

test_that("create_interpretation_object constructs a valid object", {
  vc <- valid_validated_candidate()
  io <- create_interpretation_object(vc)

  expect_s3_class(io, "interpretation_object")
  expect_identical(io$validated_candidate, vc)
  expect_identical(io$interpretation_components, list())
  expect_identical(io$execution_metadata, list())
})

test_that("create_interpretation_object rejects a non-validated_candidate", {
  expect_error(create_interpretation_object(list()))
})

# ---- Interpretation Object is never a Framework artifact --------------------

test_that("Interpretation Object is not exposed as a Framework artifact", {
  io <- valid_interpretation_object()
  expect_false(is_artifact_contract(io))
  expect_false(inherits(io, "interpretation_evidence"))
})

# ---- Workflow orchestration: run_interpretation() ---------------------------

test_that("run_interpretation orchestrates execution and returns both object and evidence", {
  result <- run_interpretation(valid_interpretation_object())

  expect_type(result, "list")
  expect_true(all(c("interpretation_object", "interpretation_evidence") %in% names(result)))
  expect_s3_class(result$interpretation_object, "interpretation_object")
  expect_s3_class(result$interpretation_evidence, "interpretation_evidence")
})

test_that("run_interpretation populates interpretation_components via the default interpreter", {
  result <- run_interpretation(valid_interpretation_object())
  expect_identical(names(result$interpretation_object$interpretation_components), "structural_check")
  expect_true(result$interpretation_object$interpretation_components$structural_check$passed)
})

test_that("run_interpretation records execution_metadata", {
  result <- run_interpretation(valid_interpretation_object())
  expect_true(isTRUE(result$interpretation_object$execution_metadata$executed))
})

# ---- Default interpreter: generic implementation only -----------------------

test_that("the default interpreter performs no pathway/SHAP/biological methodology", {
  result <- run_interpretation(valid_interpretation_object())
  details <- result$interpretation_object$interpretation_components$structural_check$details
  expect_true(grepl("generic structural check only", details))
  expect_true(result$interpretation_object$interpretation_components$structural_check$passed)
})

# ---- Custom interpreter (callback pattern) -----------------------------------

test_that("run_interpretation invokes a caller-supplied interpreter", {
  custom_interpreter <- function(interpretation_object, ...) {
    list(custom_component = list(passed = TRUE, note = "custom"))
  }

  result <- run_interpretation(valid_interpretation_object(), interpreter = custom_interpreter)
  expect_identical(names(result$interpretation_object$interpretation_components), "custom_component")
})

test_that("run_interpretation forwards additional arguments to the interpreter", {
  interpreter <- function(interpretation_object, threshold = 0, ...) {
    list(check = list(threshold_used = threshold))
  }

  result <- run_interpretation(valid_interpretation_object(), interpreter = interpreter, threshold = 7)
  expect_identical(result$interpretation_object$interpretation_components$check$threshold_used, 7)
})

# ---- Multiple independent interpretation components (Section 8) -------------

test_that("run_interpretation supports multiple independent interpretation components", {
  interpreter <- function(interpretation_object, ...) {
    list(
      component_a = list(passed = TRUE),
      component_b = list(passed = TRUE),
      component_c = list(passed = FALSE, reason = "example")
    )
  }

  result <- run_interpretation(valid_interpretation_object(), interpreter = interpreter)
  components <- result$interpretation_object$interpretation_components

  expect_identical(names(components), c("component_a", "component_b", "component_c"))
  expect_false(components$component_c$passed)
})

# ---- Failure handling --------------------------------------------------------

test_that("run_interpretation rejects a non-interpretation_object input", {
  expect_error(run_interpretation(list()))
})

test_that("run_interpretation rejects a non-function interpreter", {
  expect_error(run_interpretation(valid_interpretation_object(), interpreter = "not a function"))
})

test_that("run_interpretation rejects an interpreter that does not return a list", {
  bad_interpreter <- function(interpretation_object, ...) "not a list"
  expect_error(run_interpretation(valid_interpretation_object(), interpreter = bad_interpreter))
})

# ---- Read-only consumption of Validated Candidate ----------------------------

test_that("create_interpretation_object does not modify the supplied Validated Candidate", {
  vc <- valid_validated_candidate()
  vc_copy <- vc

  create_interpretation_object(vc)

  expect_identical(vc, vc_copy)
})

test_that("run_interpretation does not modify the Validated Candidate embedded in the object", {
  io <- valid_interpretation_object()
  vc_copy <- io$validated_candidate

  run_interpretation(io)

  expect_identical(io$validated_candidate, vc_copy)
})

# ---- Interpretation Evidence construction ------------------------------------

test_that("create_interpretation_evidence constructs a valid Interpretation Evidence", {
  result <- run_interpretation(valid_interpretation_object())
  evidence <- result$interpretation_evidence

  expect_true(is_artifact_contract(evidence))
  expect_s3_class(evidence, "interpretation_evidence")
  expect_identical(evidence$contract_type, "artifact")
  expect_identical(evidence$metadata$framework_layer, "interpretability")
  expect_identical(evidence$metadata$artifact_role, "interpretation_evidence")
})

test_that("create_interpretation_evidence defaults producer/consumer correctly", {
  result <- run_interpretation(valid_interpretation_object())
  expect_identical(result$interpretation_evidence$producer, "placeholder_algorithm")
  expect_identical(result$interpretation_evidence$consumer, "interpretation_package")
})

test_that("create_interpretation_evidence rejects forbidden metadata content", {
  io <- valid_interpretation_object()
  expect_error(create_interpretation_evidence(io, metadata = list(evidence_integration = "x")))
  expect_error(create_interpretation_evidence(io, metadata = list(interpretation_package = "x")))
  expect_error(create_interpretation_evidence(io, metadata = list(clinical_translation = "x")))
  expect_error(create_interpretation_evidence(io, metadata = list(publication_ready_interpretation = "x")))
})

test_that("create_interpretation_evidence introduces no new Framework Contract type", {
  result <- run_interpretation(valid_interpretation_object())
  evidence <- result$interpretation_evidence

  expect_identical(evidence$contract_type, "artifact")
  expect_false(inherits(evidence, "interface_contract"))
  expect_false(inherits(evidence, "dependency_contract"))
  expect_false(inherits(evidence, "verification_contract"))
})

# ---- Lineage preservation -----------------------------------------------------

test_that("Interpretation Evidence preserves complete lineage by embedding the Interpretation Object", {
  result <- run_interpretation(valid_interpretation_object())
  expect_identical(
    result$interpretation_evidence$metadata$interpretation_object,
    result$interpretation_object
  )
})

test_that("create_interpretation_evidence integrates end-to-end with Modules 06-11 construction", {
  artifact <- valid_discovery_artifact()
  spec <- create_model_specification(algorithm_id = "e2e_algorithm")
  contract <- create_model_contract(spec, artifact)
  mo <- create_model_object(spec, contract)
  to <- create_training_object(train_model(mo), mo)
  output <- create_model_output(to)
  vo <- create_validation_object(output$model_candidate, output$modeling_evidence)
  validation_result <- run_validation(vo)
  bo <- create_benchmark_object(validation_result$validation_evidence)
  benchmark_result <- run_benchmark(bo)
  cso <- create_candidate_selection_object(benchmark_result$benchmark_evidence)
  selection_result <- run_candidate_selection(cso)

  io <- create_interpretation_object(selection_result$validated_candidate)
  result <- run_interpretation(io)

  lineage_artifact <- result$interpretation_evidence$metadata$interpretation_object$validated_candidate$
    metadata$candidate_selection_object$benchmark_evidence$metadata$benchmark_object$validation_evidence$
    metadata$validation_object$model_candidate$metadata$training_object$model_object$contract$
    discovery_artifacts[[1]]
  expect_identical(lineage_artifact, artifact)
})

# ---- Verification APIs -------------------------------------------------------

test_that("validate_interpretation_object accepts a valid object and rejects an invalid one", {
  expect_true(isTRUE(validate_interpretation_object(valid_interpretation_object())))
  expect_error(validate_interpretation_object(list()))
})

test_that("validate_interpretation_evidence accepts valid evidence and rejects invalid input", {
  result <- run_interpretation(valid_interpretation_object())
  expect_true(isTRUE(validate_interpretation_evidence(result$interpretation_evidence)))
  expect_error(validate_interpretation_evidence(list()))
  expect_error(validate_interpretation_evidence(valid_interpretation_object()))
})

test_that("validate_interpretation_evidence rejects evidence with the wrong artifact_role", {
  result <- run_interpretation(valid_interpretation_object())
  evidence <- result$interpretation_evidence
  evidence$metadata$artifact_role <- "something_else"
  expect_error(validate_interpretation_evidence(evidence))
})

# ---- S3 methods --------------------------------------------------------------

test_that("print.interpretation_object executes without error and is invisible", {
  io <- valid_interpretation_object()
  expect_output(print(io), "interpretation_object")
  expect_invisible(print(io))
})

test_that("print.interpretation_evidence executes without error and is invisible", {
  result <- run_interpretation(valid_interpretation_object())
  expect_output(print(result$interpretation_evidence), "interpretation_evidence")
  expect_invisible(print(result$interpretation_evidence))
})

# ---- Public API surface -----------------------------------------------------

test_that("Module 12 exposes exactly the 5 required public functions plus the 2 print methods", {
  ns <- asNamespace("GCSignatureFramework")
  exported <- getNamespaceExports(ns)

  module_12_functions <- c(
    "create_interpretation_object", "validate_interpretation_object",
    "create_interpretation_evidence", "validate_interpretation_evidence",
    "run_interpretation"
  )

  for (fn in module_12_functions) {
    expect_true(fn %in% exported)
  }

  expect_false(is.null(getS3method("print", "interpretation_object", optional = TRUE)))
  expect_false(is.null(getS3method("print", "interpretation_evidence", optional = TRUE)))

  expect_false(".is_interpretation_object" %in% exported)
  expect_false(".default_generic_interpreter" %in% exported)
})
