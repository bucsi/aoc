import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string

import glearray.{type Array}

pub type Coord(a) {
  Coord(x: a, y: a)
}

pub fn get_x(from coord: Coord(a)) -> a {
  coord.x
}

pub fn get_y(from coord: Coord(a)) -> a {
  coord.y
}

pub fn at(array: Array(a), index: Int) -> a {
  let index = case index {
    _ if index < 0 -> 0
    i -> i
  }
  case glearray.get(array, index) {
    Ok(v) -> v
    Error(_) -> panic
  }
}

pub fn count_occurences(list: List(a)) -> Dict(a, Int) {
  list
  |> list.fold(dict.new(), fn(dict, elem) {
    dict.upsert(dict, elem, fn(value) {
      case value {
        Some(value) -> value + 1
        None -> 1
      }
    })
  })
}

pub fn eq(lhs, rhs) {
  lhs == rhs
}

pub fn ne(lhs, rhs) {
  lhs != rhs
}

pub fn undigits(numbers: List(Int), base: Int) -> Result(Int, Nil) {
  case base < 2 {
    True -> Error(Nil)
    False -> undigits_loop(numbers, base, 0)
  }
}

fn undigits_loop(numbers: List(Int), base: Int, acc: Int) -> Result(Int, Nil) {
  case numbers {
    [] -> Ok(acc)
    [digit, ..] if digit >= base -> Error(Nil)
    [digit, ..rest] -> undigits_loop(rest, base, acc * base + digit)
  }
}

pub type ParsedGrid(a) {
  GridResult(grid: dict.Dict(Coord(Int), a), rows: Int, cols: Int)
}

pub fn parse_grid(
  from input: String,
  delimited_by row_separator: String,
  split_by cell_separator: String,
  using parse_fn: fn(String) -> a,
) -> ParsedGrid(a) {
  use state, line, row <- list.index_fold(
    input |> string.split(row_separator),
    GridResult(dict.new(), 0, 0),
  )
  use GridResult(grid:, rows:, cols:), c, col <- list.index_fold(
    string.split(line, cell_separator),
    state,
  )
  GridResult(
    grid |> dict.insert(Coord(row, col), c |> parse_fn),
    row |> int.max(rows),
    col |> int.max(cols),
  )
}
