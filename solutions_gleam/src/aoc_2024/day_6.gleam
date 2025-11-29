import gleam/dict
import gleam/list
import gleam/string
import helpers.{type Coord, Coord}

pub type Direction {
  Up
  Down
  Left
  Right
}

fn turn_righ(from d: Direction) {
  case d {
    Down -> Left
    Left -> Up
    Right -> Down
    Up -> Right
  }
}

pub type Cell {
  Empty
  Obstacle
  GuardVisited
}

pub type State {
  State(
    map: dict.Dict(helpers.Coord(Int), Cell),
    direction: Direction,
    guard_pos: Coord(Int),
  )
}

pub fn parse(input: String) -> State {
  use state, line, row <- list.index_fold(
    string.split(input, "\n"),
    State(dict.new(), Up, Coord(0, 0)),
  )
  use State(map:, direction:, guard_pos:), cell, column <- list.index_fold(
    string.split(line, ""),
    state,
  )
  let map =
    map
    |> dict.insert(Coord(row, column), case cell {
      "." -> Empty
      "#" -> Obstacle
      "^" | ">" | "v" | "<" -> GuardVisited
      _ -> panic as { "Unknown cell on map: " <> cell }
    })

  let direction = case cell {
    "^" -> Up
    ">" -> Right
    "v" -> Down
    "<" -> Left
    _ -> direction
  }

  let guard_pos = case cell {
    "^" | ">" | "v" | "<" -> Coord(row, column)
    _ -> guard_pos
  }

  State(map:, direction:, guard_pos:)
}

pub fn pt_1(state: State) {
  state
  |> next_state
  |> fn(state) { state.map }
  |> dict.fold(0, fn(acc, _, v) {
    case v {
      GuardVisited -> acc + 1
      _ -> acc
    }
  })
}

fn next_state(state: State) {
  let next_guard_pos = get_next_guard_pos(state)
  case state.map |> dict.get(next_guard_pos) {
    Ok(Obstacle) -> rotate(state)
    Ok(Empty) | Ok(GuardVisited) -> step(state, next_guard_pos)
    Error(Nil) -> state
    _ -> panic as "Unexpected cell ahead of guard"
  }
}

fn rotate(state: State) -> State {
  let direction = state.direction |> turn_righ

  State(..state, direction:) |> next_state
}

fn step(state: State, next_guard_pos: Coord(Int)) -> State {
  let map = state.map |> dict.insert(next_guard_pos, GuardVisited)

  State(..state, map:, guard_pos: next_guard_pos) |> next_state
}

fn get_next_guard_pos(state: State) {
  let Coord(x, y) = state.guard_pos

  case state.direction {
    Down -> Coord(x + 1, y)
    Left -> Coord(x, y - 1)
    Right -> Coord(x, y + 1)
    Up -> Coord(x - 1, y)
  }
}

pub fn pt_2(input: State) {
  todo as "part 2 not implemented"
}
