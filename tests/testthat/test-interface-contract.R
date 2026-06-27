test_that("create_interface_contract constructs a valid contract", {
  ic <- create_interface_contract(
    producer = "Discovery",
    consumer = "Modeling",
    inputs = list("discovery_candidate"),
    outputs = list("model_candidate"),
    dependencies = list(),
    metadata = list(direction = "Discovery->Modeling")
  )

  expect_true(is_interface_contract(ic))
  expect_identical(ic$contract_type, "interface")
  expect_identical(ic$producer, "Discovery")
  expect_identical(ic$consumer, "Modeling")
})

test_that("create_interface_contract uses empty-list defaults", {
  ic <- create_interface_contract(producer = "A", consumer = "B")

  expect_identical(ic$inputs, list())
  expect_identical(ic$outputs, list())
  expect_identical(ic$dependencies, list())
  expect_identical(ic$metadata, list())
})

test_that("validate_interface_contract accepts a valid contract", {
  ic <- create_interface_contract(producer = "A", consumer = "B")
  expect_true(isTRUE(validate_interface_contract(ic)))
})

test_that("validate_interface_contract rejects a non-list object", {
  expect_error(validate_interface_contract(42))
})

test_that("validate_interface_contract rejects a contract missing required fields", {
  broken <- list(contract_type = "interface", producer = "A", consumer = "B")
  expect_error(validate_interface_contract(broken))
})

test_that("validate_interface_contract rejects the wrong contract_type", {
  broken <- list(
    contract_type = "dependency", producer = "A", consumer = "B",
    inputs = list(), outputs = list(), dependencies = list(), metadata = list()
  )
  expect_error(validate_interface_contract(broken))
})

test_that("is_interface_contract correctly distinguishes contract types", {
  ic <- create_interface_contract(producer = "A", consumer = "B")
  dc <- create_dependency_contract(producer = "A", consumer = "B")

  expect_true(is_interface_contract(ic))
  expect_false(is_interface_contract(dc))
  expect_false(is_interface_contract(NULL))
})

test_that("print.interface_contract executes without error and is invisible", {
  ic <- create_interface_contract(producer = "A", consumer = "B")
  expect_output(print(ic), "interface_contract")
  expect_invisible(print(ic))
})
