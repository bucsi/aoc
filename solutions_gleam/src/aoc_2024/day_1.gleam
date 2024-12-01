import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/string

import helpers

pub fn parse(input: String) -> #(List(Int), List(Int)) {
  input
  |> string.split("\n")
  |> list.map(string.split(_, "   "))
  |> list.map(list.map(_, helpers.parse_int(_)))
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
  let occurences = occurence(snd)
  fst
  |> list.map(fn(x) {
    let occurence = case dict.get(occurences, x) {
      Ok(occurence) -> x * occurence
      Error(_) -> 0
    }
  })
  |> int.sum
}

fn occurence(list: List(Int)) -> Dict(Int, Int) {
  list
  |> list.fold(dict.new(), fn(acc, x) {
    case dict.get(acc, x) {
      Ok(v) -> dict.insert(acc, x, v + 1)
      Error(_) -> dict.insert(acc, x, 1)
    }
  })
}
