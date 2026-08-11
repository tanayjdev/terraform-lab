locals {

  # -----------------------------
  # String Functions
  # -----------------------------

  upper_case = upper("hello")
  lower_case = lower("HELLO")
  title_case = title("hello world")

  joined     = join("-", ["a", "b", "c"])
  split_list = split(",", "a,b,c")

  replaced = replace("hello-world", "-", "_")

  sub = substr("terraform", 0, 4)

  length_string = length("terraform")

  trimmed = trim(" hello ", " ")

  trim_space = trimspace("   hello terraform   ")

  formatted = format("Server-%s-%d", "web", 1)


  # -----------------------------
  # Collection Functions
  # -----------------------------

  concat_list = concat(["a", "b"], ["c", "d"])

  merged_map = merge(
    { a = 1 },
    { b = 2 }
  )

  merged_override = merge(
    { a = 1 },
    { a = 2 }
  )

  flattened = flatten([
    ["a", "b"],
    ["c"]
  ])

  distinct_list = distinct([
    "a",
    "b",
    "a",
    "c"
  ])

  contains_b = contains(
    ["a", "b", "c"],
    "b"
  )

  second_element = element(
    ["a", "b", "c"],
    1
  )

  map_keys = keys({
    a = 1
    b = 2
  })

  map_values = values({
    a = 1
    b = 2
  })

  lookup_existing = lookup(
    { a = 1 },
    "a",
    "default"
  )

  lookup_missing = lookup(
    { a = 1 },
    "z",
    "default"
  )

  sorted = sort([
    "c",
    "a",
    "b"
  ])

  reversed = reverse([
    "a",
    "b",
    "c"
  ])

  sliced = slice(
    ["a", "b", "c", "d"],
    1,
    3
  )


  # -----------------------------
  # Numeric Functions
  # -----------------------------

  maximum = max(5, 10, 3)

  minimum = min(5, 10, 3)

  absolute = abs(-5)

  rounded_up = ceil(4.1)

  rounded_down = floor(4.9)


  # -----------------------------
  # Type Conversion
  # -----------------------------

  string_number = tostring(5)

  number_string = tonumber("5")

  list_value = tolist([
    "a",
    "b"
  ])

  set_value = toset([
    "a",
    "a",
    "b"
  ])

  map_value = tomap({
    a = 1
  })


  # -----------------------------
  # File Functions
  # -----------------------------

  generated_script = templatefile(
    "${path.module}/templates/setup.sh.tpl",
    {
      server_name = "web-server-1"
      environment = "production"
    }
  )


  # -----------------------------
  # Type Checking
  # -----------------------------

  can_convert_number = can(tonumber("123"))

  cannot_convert = can(tonumber("abc"))

  try_success = try(
    tonumber("123"),
    0
  )

  try_failure = try(
    tonumber("abc"),
    0
  )

}
