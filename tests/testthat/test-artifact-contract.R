test_that("create_artifact_contract constructs a valid contract", {
  ac <- create_artifact_contract(
    producer = "Discovery",
    consumer = "Modeling",
    inputs = list("raw_input"),
    outputs = list("discovery_candidate"),
    dependencies = list(),
    metadata = list(note = "example")
  )

  expect_true(is_artifact_contract(ac))
  expect_identical(ac$contract_type, "artifact")
  expect_identical(ac$producer, "Discovery")
  expect_identical(ac$consumer, "Modeling")
  expect_identical(ac$outputs, list("discovery_candidate"))
})

test_that("create_artifact_contract uses empty-list defaults", {
  ac <- create_artifact_contract(producer = "A", consumer = "B")

  expect_identical(ac$inputs, list())
  expect_identical(ac$outputs, list())
  expect_identical(ac$dependencies, list())
  expect_identical(ac$metadata, list())
})

test_that("validate_artifact_contract accepts a valid contract", {
  ac <- create_artifact_contract(producer = "A", consumer = "B")
  expect_true(isTRUE(validate_artifact_contract(ac)))
})

test_that("validate_artifact_contract rejects a non-list object", {
  expect_error(validate_artifact_contract("not a contract"))
})

test_that("validate_artifact_contract rejects a contract missing required fields", {
  broken <- list(contract_type = "artifact", producer = "A", consumer = "B")
  expect_error(validate_artifact_contract(broken))
})

test_that("validate_artifact_contract rejects the wrong contract_type", {
  broken <- list(
    contract_type = "interface", producer = "A", consumer = "B",
    inputs = list(), outputs = list(), dependencies = list(), metadata = list()
  )
  expect_error(validate_artifact_contract(broken))
})

test_that("validate_artifact_contract rejects empty producer/consumer", {
  broken <- list(
    contract_type = "artifact", producer = "", consumer = "B",
    inputs = list(), outputs = list(), dependencies = list(), metadata = list()
  )
  expect_error(validate_artifact_contract(broken))
})

test_that("is_artifact_contract correctly distinguishes contract types", {
  ac <- create_artifact_contract(producer = "A", consumer = "B")
  ic <- create_interface_contract(producer = "A", consumer = "B")

  expect_true(is_artifact_contract(ac))
  expect_false(is_artifact_contract(ic))
  expect_false(is_artifact_contract(list()))
})

test_that("print.artifact_contract executes without error and is invisible", {
  ac <- create_artifact_contract(producer = "A", consumer = "B")
  expect_output(print(ac), "artifact_contract")
  expect_invisible(print(ac))
})
