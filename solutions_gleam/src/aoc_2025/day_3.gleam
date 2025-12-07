import gleam/int
import gleam/list
import gleam/string

import helpers
import helpers/unsafe_int
import helpers/unsafe_result

import iv

pub fn pt_1(input: String) {
  input
  |> string.split("\n")
  |> list.map(string.split(_, ""))
  |> list.map(list.combination_pairs)
  |> list.map(list.map(_, fn(tpl) { { tpl.0 <> tpl.1 } |> unsafe_int.parse }))
  |> list.map(fn(possible_joltages) {
    let assert Ok(max_joltage) = possible_joltages |> list.max(int.compare)
    max_joltage
  })
  |> int.sum
}

pub fn pt_2(input: String) {
  input
  |> string.split("\n")
  |> list.map(string.split(_, ""))
  |> list.map(list.map(_, unsafe_int.parse))
  |> list.map(get_max_joltage)
  |> int.sum
}

fn get_max_joltage(possible_digits: List(Int)) -> Int {
  let array = iv.from_list(possible_digits)
  let digits_to_still_fill = 11

  max_joltage_loop(0, array, digits_to_still_fill, iv.new())
}

fn max_joltage_loop(
  starting_position,
  possible_digits: iv.Array(Int),
  digits_to_still_fill: Int,
  digits_selected: iv.Array(Int),
) {
  let assert Ok(sliced) = {
    iv.slice(
      possible_digits,
      starting_position,
      iv.length(possible_digits) - digits_to_still_fill - starting_position,
    )
    |> echo
  }
    as "iv slice"

  let #(max, max_index) = sliced |> max
  let digits_selected = digits_selected |> iv.append(max)
  case digits_selected |> iv.length {
    12 ->
      digits_selected
      |> iv.to_list
      |> helpers.undigits(10)
      |> unsafe_result.unwrap

    _ ->
      max_joltage_loop(
        max_index + starting_position + 1,
        possible_digits,
        digits_to_still_fill - 1,
        digits_selected,
      )
  }
}

fn max(array: iv.Array(Int)) -> #(Int, Int) {
  use #(max, max_index), current, index <- iv.index_fold(array, #(-1, -1))
  case current > max {
    True -> #(current, index)

    _ -> #(max, max_index)
  }
}
