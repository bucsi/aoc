import gleam/int
import gleam/list
import gleam/string
import helpers.{parse_int}

pub type Input {
  Input(lines: List(List(Int)))
}

pub fn parse(input: String) -> #(Input, Input) {
  let numbers =
    input
    |> string.split("\n")
    |> list.map(string.split(_, " "))
    |> list.map(list.map(_, parse_int))

  let reversed =
    numbers
    |> list.map(list.reverse)
    |> Input
  let numbers = numbers |> Input
  #(reversed, numbers)
}

pub fn pt_1(input: #(Input, Input)) {
  { input.0 }.lines
  |> list.map(calculate_differences(_, []))
  |> int.sum
}

fn calculate_differences(nums: List(Int), state: List(List(Int))) {
  let diffs =
    nums
    |> list.window_by_2
    |> list.map(fn(pair) {
      let #(fst, snd) = pair
      fst - snd
    })

  case list.all(diffs, fn(i) { i == 0 }) {
    True -> interpolate([diffs, nums, ..state])
    False -> calculate_differences(diffs, [nums, ..state])
  }
}

fn interpolate(differences: List(List(Int))) {
  case differences {
    [first, second, ..rest] ->
      interpolate([[get_next_value(first, second), ..second], ..rest])
    [last] -> {
      let assert [head, ..] = last
      head
    }
    [] -> panic
  }
}

fn get_next_value(a: List(Int), b: List(Int)) {
  let assert [a_head, ..] = a
  let assert [b_head, ..] = b
  a_head + b_head
}

pub fn pt_2(input: #(Input, Input)) {
  { input.1 }.lines
  |> list.map(calculate_differences(_, []))
  |> int.sum
}
