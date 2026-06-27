test_that("create_dependency_contract constructs a valid contract", {
  dc <- create_dependency_contract(
    producer = "Discovery",
    consumer = "Modeling",
    inputs = list(),
    outputs = list(),
    dependencies = list("discovery_artifact_contract"),
    metadata = list(sequential = TRUE)
  )

  expect_true(is_dependency_contract(dc))
  expect_identical(dc$contract_type, "dependency")
  expect_identical(dc$dependencies, list("discovery_artifact_contract"))
})

test_that("create_dependency_contract uses empty-list defaults", {
  dc <- create_dependency_contract(producer = "A", consumer = "B")

  expect_identical(dc$inputs, list())
  expect_identical(dc$outputs, list())
  expect_identical(dc$dependencies, list())
  expect_identical(dc$metadata, list())
})

test_that("validate_dependency_contract accepts a valid contract", {
  dc <- create_dependency_contract(producer = "A", consumer = "B")
  expect_true(isTRUE(validate_dependency_contract(dc)))
})

test_that("validate_dependency_contract rejects a non-list object", {
  expect_error(validate_dependency_contract(TRUE))
})

test_that("validate_dependency_contract rejects a contract missing required fields", {
  broken <- list(contract_type = "dependency", producer = "A", consumer = "B")
  expect_error(validate_dependency_contract(broken))
})

test_that("validate_dependency_contract rejects the wrong contract_type", {
  broken <- list(
    contract_type = "verification", producer = "A", consumer = "B",
    inputs = list(), outputs = list(), dependencies = list(), metadata = list()
  )
  expect_error(validate_dependency_contract(broken))
})

test_that("is_dependency_contract correctly distinguishes contract types", {
  dc <- create_dependency_contract(producer = "A", consumer = "B")
  vc <- create_verification_contract(producer = "A", consumer = "B")

  expect_true(is_dependency_contract(dc))
  expect_false(is_dependency_contract(vc))
})

test_that("print.dependency_contract executes without error and is invisible", {
  dc <- create_dependency_contract(producer = "A", consumer = "B")
  expect_output(print(dc), "dependency_contract")
  expect_invisible(print(dc))
})
