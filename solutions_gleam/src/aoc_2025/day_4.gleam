import gleam/dict
import gleam/list
import gleam/order
import gleam/result
import gleam/string

import helpers.{type Coord, Coord}

pub type Cell {
  Roll
  Empty
}

pub fn parse(input: String) -> #(dict.Dict(Coord(Int), Cell), Int, Int) {
  use #(dict, row, col), line, i <- list.index_fold(
    input |> string.split("\n"),
    #(dict.new(), 0, 0),
  )
  use #(dict, _, _), char, j <- list.index_fold(line |> string.split(""), #(
    dict,
    row,
    col,
  ))
  #(char |> char_to_cell |> dict.insert(dict, Coord(i, j), _), i, j)
}

fn char_to_cell(char: String) {
  case char {
    "@" -> Roll
    "." -> Empty

    _ -> panic as "Unknown cell"
  }
}

pub fn pt_1(map: #(dict.Dict(Coord(Int), Cell), Int, Int)) {
  let #(map, rows, cols) = map

  list.map(list.range(0, rows), fn(i) {
    list.map(list.range(0, cols), fn(j) { map |> neighbors(i, j) })
    |> list.filter(can_be_moved)
    |> echo
  })
  |> list.length
}

fn neighbors(map: dict.Dict(Coord(Int), Cell), x: Int, y: Int) -> List(Cell) {
  let left = map |> dict.get(Coord(x - 1, y))

  let topleft = map |> dict.get(Coord(x - 1, y - 1))
  let top = map |> dict.get(Coord(x, y - 1))
  let topright = map |> dict.get(Coord(x + 1, y - 1))

  let right = map |> dict.get(Coord(x + 1, y))

  let bottomleft = map |> dict.get(Coord(x + 1, y - 1))
  let bottom = map |> dict.get(Coord(x, y + 1))
  let bottomright = map |> dict.get(Coord(x + 1, y + 1))

  [left, topleft, top, topright, right, bottomleft, bottom, bottomright]
  |> result.values
}

fn can_be_moved(neighbors: List(Cell)) -> Bool {
  neighbors |> list.filter(fn(cell) { cell == Roll }) |> list.length <= 4
}

pub fn pt_2(map: #(dict.Dict(Coord(Int), Cell), Int, Int)) {
  todo as "part 2 not implemented"
}
