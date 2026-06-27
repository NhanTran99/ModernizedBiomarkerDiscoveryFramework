test_that("create_verification_contract constructs a valid contract", {
  vc <- create_verification_contract(
    producer = "Discovery",
    consumer = "Modeling",
    inputs = list(),
    outputs = list(),
    dependencies = list(),
    metadata = list(
      categories = c("contract_compliance", "interface_compliance",
                      "artifact_completeness", "traceability_compliance",
                      "downstream_compatibility")
    )
  )

  expect_true(is_verification_contract(vc))
  expect_identical(vc$contract_type, "verification")
})

test_that("create_verification_contract uses empty-list defaults", {
  vc <- create_verification_contract(producer = "A", consumer = "B")

  expect_identical(vc$inputs, list())
  expect_identical(vc$outputs, list())
  expect_identical(vc$dependencies, list())
  expect_identical(vc$metadata, list())
})

test_that("validate_verification_contract accepts a valid contract", {
  vc <- create_verification_contract(producer = "A", consumer = "B")
  expect_true(isTRUE(validate_verification_contract(vc)))
})

test_that("validate_verification_contract rejects a non-list object", {
  expect_error(validate_verification_contract(NA))
})

test_that("validate_verification_contract rejects a contract missing required fields", {
  broken <- list(contract_type = "verification", producer = "A", consumer = "B")
  expect_error(validate_verification_contract(broken))
})

test_that("validate_verification_contract rejects the wrong contract_type", {
  broken <- list(
    contract_type = "artifact", producer = "A", consumer = "B",
    inputs = list(), outputs = list(), dependencies = list(), metadata = list()
  )
  expect_error(validate_verification_contract(broken))
})

test_that("is_verification_contract correctly distinguishes contract types", {
  vc <- create_verification_contract(producer = "A", consumer = "B")
  ac <- create_artifact_contract(producer = "A", consumer = "B")

  expect_true(is_verification_contract(vc))
  expect_false(is_verification_contract(ac))
})

test_that("print.verification_contract executes without error and is invisible", {
  vc <- create_verification_contract(producer = "A", consumer = "B")
  expect_output(print(vc), "verification_contract")
  expect_invisible(print(vc))
})
