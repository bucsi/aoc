import gleam/dict
import gleam/io
import gleam/list
import gleam/string

import glearray

import helpers.{at}

pub type Item {
  Galaxy
  Empty
}

pub fn pt_1(input: String) {
  let array =
    input
    |> string.split("\n")
    |> list.map(string.to_graphemes)
    |> list.map(fn(row) {
      row
      |> list.map(fn(item) {
        case item {
          "." -> Empty
          "#" -> Galaxy
          _ -> panic
        }
      })
    })
    |> list.map(glearray.from_list)
    |> glearray.from_list

  let col_length = glearray.length(array) - 1
  let row_length = glearray.length(array |> at(0)) - 1

  todo
  // let map =
  //   list.range(0, col_length)
  //   |> list.fold(from: dict.new(), with: fn(map, col) {
  //     list.range(0, row_length)
  //     |> list.fold(from: map, with: fn(map, row) {
  //       let item = array |> at(col) |> at(row)
  //       io.debug(item)
  //       dict.insert(map, #(col, row), item)
  //     })
  //   })
}

fn create_empty_row(row_length) {
  list.range(0, row_length)
  |> list.map(fn(_) { Empty })
  |> glearray.from_list
}

pub fn pt_2(input: String) {
  todo as "part 2 not implemented"
}
