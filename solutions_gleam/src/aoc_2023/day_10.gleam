import gleam/int
import gleam/list
import gleam/string
import helpers.{at}

import glearray.{type Array}

pub type Pipe {
  NorthSouth
  EastWest
  NorthEast
  NorthWest
  SouthWest
  SouthEast
  Ground
  Start
}

pub type Direction {
  North
  South
  East
  West
}

fn direction_to_coord_offset(d: Direction) -> #(Int, Int) {
  case d {
    North -> #(-1, 0)
    South -> #(1, 0)
    East -> #(0, 1)
    West -> #(0, -1)
  }
}

pub type Input {
  Input(
    map: Array(Array(Pipe)),
    initial_dir: Direction,
    start_row: Int,
    start_col: Int,
  )
}

pub fn parse(input: String) {
  let array =
    input
    |> string.split("\n")
    |> list.map(string.to_graphemes)
    |> list.map(list.map(_, to_pipe))
    |> list.map(glearray.from_list)
    |> glearray.from_list
  let array_length = glearray.length(array) |> int.subtract(1)
  let row_length = glearray.length(array |> at(0)) |> int.subtract(1)

  let start_coords =
    list.range(0, array_length)
    |> list.fold(#(-1, -1), fn(state, i) {
      let row = array |> at(i)
      list.range(0, row_length)
      |> list.fold(state, fn(state, j) {
        let item = row |> at(j)
        case item {
          Start -> #(i, j)
          _ -> state
        }
      })
    })

  let north = array |> at(start_coords.0 - 1) |> at(start_coords.1)
  let east = array |> at(start_coords.0) |> at(start_coords.1 + 1)
  let south = array |> at(start_coords.0 + 1) |> at(start_coords.1)
  let west = array |> at(start_coords.0) |> at(start_coords.1 - 1)

  let initial_dir = case north, south, east, west {
    NorthSouth, _, _, _ | SouthWest, _, _, _ | SouthEast, _, _, _ -> North
    _, NorthSouth, _, _ | _, NorthWest, _, _ | _, NorthEast, _, _ -> South
    _, _, EastWest, _ | _, _, NorthWest, _ | _, _, SouthWest, _ -> East
    _, _, _, EastWest | _, _, _, NorthEast | _, _, _, SouthEast -> West
    _, _, _, _ -> panic
  }

  let c = direction_to_coord_offset(initial_dir)

  Input(array, initial_dir, start_coords.0 + c.0, start_coords.1 + c.1)
}

fn to_pipe(char: String) -> Pipe {
  case char {
    "|" -> NorthSouth
    "-" -> EastWest
    "L" -> NorthEast
    "J" -> NorthWest
    "7" -> SouthWest
    "F" -> SouthEast
    "S" -> Start
    _ -> Ground
  }
}

pub type State {
  State(
    map: Array(Array(Pipe)),
    previous_direction: Direction,
    curr_row: Int,
    curr_col: Int,
    steps: Int,
  )
}

fn current_tile(s: State) {
  s.map |> at(s.curr_row) |> at(s.curr_col)
}

pub fn step(s: State) {
  let _dir = case current_tile(s), s.previous_direction {
    NorthSouth, North -> North
    NorthSouth, South -> South
    EastWest, East -> East
    EastWest, West -> West
    NorthEast, West -> North
    NorthEast, South -> East
    NorthWest, East -> North
    NorthWest, South -> West
    SouthWest, North -> West
    SouthWest, East -> South
    SouthEast, West -> South
    SouthEast, North -> East
    _, _ -> panic
  }
  // io.print("Going to: ")
  // io.debug(dir)
}

pub fn pt_1(input: Input) {
  {
    recurse(State(
      input.map,
      input.initial_dir,
      input.start_row,
      input.start_col,
      1,
    ))
  }.steps
  / 2
}

fn recurse(s: State) {
  let current_tile = current_tile(s)
  // io.print("Currently at ")
  // io.debug(current_tile)
  // io.print("Came from ")
  // io.debug(s.previous_direction)
  case current_tile {
    Start -> s
    _ -> {
      let dir = step(s)
      let c = direction_to_coord_offset(dir)

      recurse(
        State(
          ..s,
          previous_direction: dir,
          curr_row: s.curr_row + c.0,
          curr_col: s.curr_col + c.1,
          steps: s.steps + 1,
        ),
      )
    }
  }
}

pub fn pt_2(_input: Input) {
  0
}
