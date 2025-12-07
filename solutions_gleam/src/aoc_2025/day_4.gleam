import gleam/dict
import gleam/function
import gleam/list
import gleam/result
import gleam/string

import helpers.{type Coord, Coord}

pub type Cell {
  Roll
  Empty
}

pub fn parse(input: String) {
  helpers.parse_grid(
    from: input,
    delimited_by: "\n",
    split_by: "",
    using: char_to_cell,
  )
}

fn char_to_cell(char: String) {
  case char {
    "@" -> Roll
    "." -> Empty

    _ -> panic as "Unknown cell"
  }
}

pub fn pt_1(input: helpers.ParsedGrid(Cell)) {
  let helpers.GridResult(map, rows, cols) = input

  list.map(list.range(0, rows), fn(i) {
    list.map(list.range(0, cols), fn(j) {
      case map |> dict.get(Coord(i, j)) {
        Ok(Roll) ->
          neighbors(map, i, j)
          |> can_be_moved
        // |> echo as "can be moved"
        _ -> False
      }
    })
    // |> dump
  })
  |> list.flatten
  |> list.filter(function.identity)
  |> list.length
}

// fn dump(l: List(Bool)) {
//   list.each(l, fn(i) {
//     io.print(case i {
//       True -> "x"
//       _ -> "."
//     })
//   })
//   io.println("")

//   l
// }

fn neighbors(map: dict.Dict(Coord(Int), Cell), x: Int, y: Int) -> List(Cell) {
  // echo Coord(x, y) as "checking"
  let left = map |> dict.get(Coord(x, y - 1))

  let topleft = map |> dict.get(Coord(x - 1, y - 1))
  let top = map |> dict.get(Coord(x - 1, y))
  let topright = map |> dict.get(Coord(x - 1, y + 1))

  let right = map |> dict.get(Coord(x, y + 1))

  let bottomleft = map |> dict.get(Coord(x + 1, y - 1))
  let bottom = map |> dict.get(Coord(x + 1, y))
  let bottomright = map |> dict.get(Coord(x + 1, y + 1))

  [left, topleft, top, topright, right, bottomleft, bottom, bottomright]
  // |> echo
  |> result.values
}

fn can_be_moved(neighbors: List(Cell)) -> Bool {
  neighbors |> list.filter(fn(cell) { cell == Roll }) |> list.length < 4
}

pub fn pt_2(input: helpers.ParsedGrid(Cell)) {
  let helpers.GridResult(map, rows, cols) = input

  { #(map, 0) |> remove_rolls_that_can_be_moved(rows, cols) }.1
}

fn remove_rolls_that_can_be_moved(
  map_and_total_removed: #(dict.Dict(Coord(Int), Cell), Int),
  rows: Int,
  cols: Int,
) -> #(dict.Dict(Coord(Int), Cell), Int) {
  let #(map, total_removed) = map_and_total_removed
  let can_be_removed_map =
    list.map(list.range(0, rows), fn(i) {
      list.map(list.range(0, cols), fn(j) {
        case map |> dict.get(Coord(i, j)) {
          Ok(Roll) ->
            neighbors(map, i, j)
            |> can_be_moved
          // |> echo as "can be moved"
          _ -> False
        }
      })
      |> list.index_map(fn(v, i) { #(i, v) })
      |> dict.from_list
    })
    |> list.index_map(fn(v, i) { #(i, v) })
    |> dict.from_list

  let total_removed =
    total_removed
    + {
      can_be_removed_map
      |> dict.values
      |> list.map(dict.values)
      |> list.flatten
      |> list.filter(function.identity)
      |> list.length
    }

  let new_map = {
    use new_map, i <- list.fold(list.range(0, rows), dict.new())
    use new_map, j <- list.fold(list.range(0, cols), new_map)
    let coord = Coord(i, j)
    // |> echo as "checking coord"
    let assert Ok(cell) = map |> dict.get(coord) as "Could not get cell"
    new_map
    |> dict.insert(
      coord,
      case can_be_removed_map |> dict.get(i) |> result.try(dict.get(_, j)) {
        Ok(True) -> Empty
        _ -> cell
      },
    )
  }

  case new_map != map {
    True ->
      remove_rolls_that_can_be_moved(#(new_map, total_removed), rows, cols)
    _ -> #(new_map, total_removed)
  }
}
