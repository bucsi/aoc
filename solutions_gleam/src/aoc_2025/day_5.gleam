import gleam/function
import gleam/int
import gleam/list
import gleam/string

import helpers/unsafe_int

fn make_validity_function(lower: Int, upper: Int) -> fn(Int) -> Bool {
  fn(id: Int) { lower <= id && id <= upper }
}

pub fn pt_1(input: String) {
  let assert [validations, ids] = input |> string.split("\n\n")
  let validations =
    validations
    |> string.split("\n")
    |> list.map(fn(validation) {
      let assert [lower, upper] = validation |> string.split("-")
      let lower = unsafe_int.parse(lower)
      let upper = unsafe_int.parse(upper)

      make_validity_function(lower, upper)
    })

  ids
  |> string.split("\n")
  |> list.map(fn(id) {
    let id = unsafe_int.parse(id)
    use validation <- list.map(validations)
    validation(id)
  })
  |> list.filter(list.any(_, function.identity))
  |> list.length
}

pub fn pt_2(input: String) {
  let assert [validations, _] = input |> string.split("\n\n")
  let validations =
    validations
    |> string.split("\n")
    |> list.map(fn(validation) {
      let assert [lower, upper] = validation |> string.split("-")
      let lower = unsafe_int.parse(lower)
      let upper = unsafe_int.parse(upper)

      #(lower, upper)
    })
    |> list.sort(fn(a, b) { a.0 |> int.compare(b.0) })
    |> echo

  let assert [#(lower, upper), ..rest_validations] = validations

  let #(valid_id_count, last_range_lower, last_range_upper) = {
    use #(valid_id_count, prev_lower, prev_upper), #(next_lower, next_upper) <- list.fold(
      rest_validations,
      #(0, lower, upper),
    )
    case prev_upper >= next_lower {
      True -> #(valid_id_count, prev_lower, int.max(next_upper, prev_upper))
      _ -> #(
        valid_id_count + { prev_upper - prev_lower } + 1,
        next_lower,
        next_upper,
      )
    }
    |> echo
  }

  valid_id_count + { last_range_upper - last_range_lower } + 1
}
