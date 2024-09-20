import gleam/dict
import gleam/io
import gleam/iterator
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

  let array = expand_rows(array, 0, row_length)
  let array = expand_cols(array, 0, col_length)

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

  array
  |> glearray.iterate
  |> iterator.each(fn(row) {
    row
    |> glearray.iterate
    |> iterator.each(fn(item) {
      case item {
        Galaxy -> io.print("#")
        Empty -> io.print(".")
      }
    })
    io.print("\n")
  })
}

fn expand_rows(array, index, row_length) {
  case index <= row_length {
    False -> array
    True -> {
      let empty_row = create_empty_row(row_length)
      let is_empty =
        array
        |> at(index)
        |> glearray.iterate
        |> iterator.all(fn(item) { item == Empty })

      case is_empty {
        True -> {
          let assert Ok(new_array) =
            glearray.copy_insert(array, index, empty_row)
          expand_rows(new_array, index + 2, row_length)
        }
        False -> expand_rows(array, index + 1, row_length)
      }
    }
  }
}

fn expand_cols(array, index, col_length) {
  todo
}

fn create_empty_row(row_length) {
  list.range(0, row_length)
  |> list.map(fn(_) { Empty })
  |> glearray.from_list
}

pub fn pt_2(input: String) {
  todo as "part 2 not implemented"
}
