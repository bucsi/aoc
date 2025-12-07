import gleam/dict
import gleam/int
import gleam/list
import gleam/string

import helpers
import helpers/unsafe_int

pub fn parse(input: String) -> #(List(Int), List(Int)) {
  input
  |> string.split("\n")
  |> list.map(string.split(_, "   "))
  |> list.map(list.map(_, unsafe_int.parse))
  |> list.flatten
  |> list.index_fold(#([], []), fn(acc, x, i) {
    case i % 2 {
      0 -> #([x, ..acc.0], acc.1)
      _ -> #(acc.0, [x, ..acc.1])
    }
  })
}

pub fn pt_1(input: #(List(Int), List(Int))) -> Int {
  let #(fst, snd) = input

  list.zip(list.sort(fst, int.compare), list.sort(snd, int.compare))
  |> list.map(fn(tpl) { tpl.1 - tpl.0 |> int.absolute_value })
  |> int.sum
}

pub fn pt_2(input: #(List(Int), List(Int))) {
  let #(fst, snd) = input
  let occurences = helpers.count_occurences(snd)
  fst
  |> list.map(similarity_score(_, occurences))
  |> int.sum
}

fn similarity_score(value, occurences) {
  case dict.get(occurences, value) {
    Ok(occurence) -> value * occurence
    Error(_) -> 0
  }
}
