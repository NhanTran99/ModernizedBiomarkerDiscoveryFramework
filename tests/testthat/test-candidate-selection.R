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

valid_benchmark_evidence <- function() {
  output <- create_model_output(valid_training_object())
  vo <- create_validation_object(output$model_candidate, output$modeling_evidence)
  validation_result <- run_validation(vo)
  bo <- create_benchmark_object(validation_result$validation_evidence)
  run_benchmark(bo)$benchmark_evidence
}

valid_candidate_selection_object <- function() {
  create_candidate_selection_object(valid_benchmark_evidence())
}

# ---- Candidate Selection Object construction --------------------------------

test_that("create_candidate_selection_object constructs a valid object", {
  be <- valid_benchmark_evidence()
  cso <- create_candidate_selection_object(be)

  expect_s3_class(cso, "candidate_selection_object")
  expect_identical(cso$benchmark_evidence, be)
  expect_identical(cso$selection_components, list())
  expect_identical(cso$execution_metadata, list())
})

test_that("create_candidate_selection_object rejects a non-benchmark_evidence", {
  expect_error(create_candidate_selection_object(list()))
})

# ---- Candidate Selection Object is never a Framework artifact ---------------

test_that("Candidate Selection Object is not exposed as a Framework artifact", {
  cso <- valid_candidate_selection_object()
  expect_false(is_artifact_contract(cso))
  expect_false(inherits(cso, "validated_candidate"))
})

# ---- Workflow orchestration: run_candidate_selection() -----------------------

test_that("run_candidate_selection orchestrates execution and returns both object and candidate", {
  result <- run_candidate_selection(valid_candidate_selection_object())

  expect_type(result, "list")
  expect_true(all(c("candidate_selection_object", "validated_candidate") %in% names(result)))
  expect_s3_class(result$candidate_selection_object, "candidate_selection_object")
  expect_s3_class(result$validated_candidate, "validated_candidate")
})

test_that("run_candidate_selection populates selection_components via the default selector", {
  result <- run_candidate_selection(valid_candidate_selection_object())
  expect_identical(names(result$candidate_selection_object$selection_components), "structural_check")
  expect_true(result$candidate_selection_object$selection_components$structural_check$passed)
})

test_that("run_candidate_selection records execution_metadata", {
  result <- run_candidate_selection(valid_candidate_selection_object())
  expect_true(isTRUE(result$candidate_selection_object$execution_metadata$executed))
})

# ---- Default selector: generic implementation only ---------------------------

test_that("the default selector performs no ranking/statistical/biological/ML methodology", {
  result <- run_candidate_selection(valid_candidate_selection_object())
  details <- result$candidate_selection_object$selection_components$structural_check$details
  expect_true(grepl("generic structural check only", details))
  expect_true(result$candidate_selection_object$selection_components$structural_check$passed)
})

# ---- Custom selector (callback pattern) --------------------------------------

test_that("run_candidate_selection invokes a caller-supplied selector", {
  custom_selector <- function(candidate_selection_object, ...) {
    list(custom_component = list(passed = TRUE, note = "custom"))
  }

  result <- run_candidate_selection(valid_candidate_selection_object(), selector = custom_selector)
  expect_identical(names(result$candidate_selection_object$selection_components), "custom_component")
})

test_that("run_candidate_selection forwards additional arguments to the selector", {
  selector <- function(candidate_selection_object, threshold = 0, ...) {
    list(check = list(threshold_used = threshold))
  }

  result <- run_candidate_selection(valid_candidate_selection_object(), selector = selector, threshold = 3)
  expect_identical(result$candidate_selection_object$selection_components$check$threshold_used, 3)
})

# ---- Multiple independent selection components (Section 8) ------------------

test_that("run_candidate_selection supports multiple independent selection components", {
  selector <- function(candidate_selection_object, ...) {
    list(
      component_a = list(passed = TRUE),
      component_b = list(passed = TRUE),
      component_c = list(passed = FALSE, reason = "example")
    )
  }

  result <- run_candidate_selection(valid_candidate_selection_object(), selector = selector)
  components <- result$candidate_selection_object$selection_components

  expect_identical(names(components), c("component_a", "component_b", "component_c"))
  expect_false(components$component_c$passed)
})

# ---- Failure handling --------------------------------------------------------

test_that("run_candidate_selection rejects a non-candidate_selection_object input", {
  expect_error(run_candidate_selection(list()))
})

test_that("run_candidate_selection rejects a non-function selector", {
  expect_error(run_candidate_selection(valid_candidate_selection_object(), selector = "not a function"))
})

test_that("run_candidate_selection rejects a selector that does not return a list", {
  bad_selector <- function(candidate_selection_object, ...) "not a list"
  expect_error(run_candidate_selection(valid_candidate_selection_object(), selector = bad_selector))
})

# ---- Read-only consumption of Benchmark Evidence ----------------------------

test_that("create_candidate_selection_object does not modify the supplied Benchmark Evidence", {
  be <- valid_benchmark_evidence()
  be_copy <- be

  create_candidate_selection_object(be)

  expect_identical(be, be_copy)
})

test_that("run_candidate_selection does not modify the Benchmark Evidence embedded in the object", {
  cso <- valid_candidate_selection_object()
  be_copy <- cso$benchmark_evidence

  run_candidate_selection(cso)

  expect_identical(cso$benchmark_evidence, be_copy)
})

# ---- Validated Candidate construction ----------------------------------------

test_that("create_validated_candidate constructs a valid Validated Candidate", {
  result <- run_candidate_selection(valid_candidate_selection_object())
  candidate <- result$validated_candidate

  expect_true(is_artifact_contract(candidate))
  expect_s3_class(candidate, "validated_candidate")
  expect_identical(candidate$contract_type, "artifact")
  expect_identical(candidate$metadata$framework_layer, "validation_benchmark")
  expect_identical(candidate$metadata$artifact_role, "validated_candidate")
})

test_that("create_validated_candidate defaults producer/consumer correctly", {
  result <- run_candidate_selection(valid_candidate_selection_object())
  expect_identical(result$validated_candidate$producer, "placeholder_algorithm")
  expect_identical(result$validated_candidate$consumer, "interpretability")
})

test_that("create_validated_candidate rejects forbidden metadata content", {
  cso <- valid_candidate_selection_object()
  expect_error(create_validated_candidate(cso, metadata = list(scientific_interpretation = "x")))
  expect_error(create_validated_candidate(cso, metadata = list(biological_recommendation = "x")))
  expect_error(create_validated_candidate(cso, metadata = list(clinical_recommendation = "x")))
  expect_error(create_validated_candidate(cso, metadata = list(publication_ready_conclusions = "x")))
  expect_error(create_validated_candidate(cso, metadata = list(therapeutic_recommendations = "x")))
})

test_that("create_validated_candidate introduces no new Framework Contract type", {
  result <- run_candidate_selection(valid_candidate_selection_object())
  candidate <- result$validated_candidate

  expect_identical(candidate$contract_type, "artifact")
  expect_false(inherits(candidate, "interface_contract"))
  expect_false(inherits(candidate, "dependency_contract"))
  expect_false(inherits(candidate, "verification_contract"))
})

# ---- Lineage preservation -----------------------------------------------------

test_that("Validated Candidate preserves complete lineage by embedding the Candidate Selection Object", {
  result <- run_candidate_selection(valid_candidate_selection_object())
  expect_identical(
    result$validated_candidate$metadata$candidate_selection_object,
    result$candidate_selection_object
  )
})

test_that("create_validated_candidate integrates end-to-end with Modules 06-10 construction", {
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
  result <- run_candidate_selection(cso)

  lineage_artifact <- result$validated_candidate$metadata$candidate_selection_object$benchmark_evidence$
    metadata$benchmark_object$validation_evidence$metadata$validation_object$model_candidate$
    metadata$training_object$model_object$contract$discovery_artifacts[[1]]
  expect_identical(lineage_artifact, artifact)
})

# ---- Verification APIs -------------------------------------------------------

test_that("validate_candidate_selection_object accepts a valid object and rejects an invalid one", {
  expect_true(isTRUE(validate_candidate_selection_object(valid_candidate_selection_object())))
  expect_error(validate_candidate_selection_object(list()))
})

test_that("validate_validated_candidate accepts a valid candidate and rejects invalid input", {
  result <- run_candidate_selection(valid_candidate_selection_object())
  expect_true(isTRUE(validate_validated_candidate(result$validated_candidate)))
  expect_error(validate_validated_candidate(list()))
  expect_error(validate_validated_candidate(valid_candidate_selection_object()))
})

test_that("validate_validated_candidate rejects a candidate with the wrong artifact_role", {
  result <- run_candidate_selection(valid_candidate_selection_object())
  candidate <- result$validated_candidate
  candidate$metadata$artifact_role <- "something_else"
  expect_error(validate_validated_candidate(candidate))
})

# ---- S3 methods --------------------------------------------------------------

test_that("print.candidate_selection_object executes without error and is invisible", {
  cso <- valid_candidate_selection_object()
  expect_output(print(cso), "candidate_selection_object")
  expect_invisible(print(cso))
})

test_that("print.validated_candidate executes without error and is invisible", {
  result <- run_candidate_selection(valid_candidate_selection_object())
  expect_output(print(result$validated_candidate), "validated_candidate")
  expect_invisible(print(result$validated_candidate))
})

# ---- Public API surface -----------------------------------------------------

test_that("Module 11 exposes exactly the 5 required public functions plus the 2 print methods", {
  ns <- asNamespace("GCSignatureFramework")
  exported <- getNamespaceExports(ns)

  module_11_functions <- c(
    "create_candidate_selection_object", "validate_candidate_selection_object",
    "create_validated_candidate", "validate_validated_candidate",
    "run_candidate_selection"
  )

  for (fn in module_11_functions) {
    expect_true(fn %in% exported)
  }

  expect_false(is.null(getS3method("print", "candidate_selection_object", optional = TRUE)))
  expect_false(is.null(getS3method("print", "validated_candidate", optional = TRUE)))

  expect_false(".is_candidate_selection_object" %in% exported)
  expect_false(".default_generic_selector" %in% exported)
})
