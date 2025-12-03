import gleam/int
import gleam/list
import gleam/string
import helpers

pub fn pt_1(input: String) {
  input
  |> string.split("\n")
  |> list.map(string.split(_, ""))
  |> list.map(list.combination_pairs)
  |> list.map(list.map(_, fn(tpl) { { tpl.0 <> tpl.1 } |> helpers.parse_int }))
  |> list.map(fn(possible_joltages) {
    let assert Ok(max_joltage) = possible_joltages |> list.max(int.compare)
    max_joltage
  })
  |> int.sum
}

pub fn pt_2(input: String) {
  todo
}
