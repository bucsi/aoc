import gleam/int
import gleam/list
import gleam/string
import helpers

pub type Op {
  Left(distance: Int)
  Right(distance: Int)
}

pub fn parse(input: String) -> List(Op) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    let assert Ok(#(direction, distance)) = string.pop_grapheme(line)
      as "dirty split"

    case direction {
      "L" -> Left(distance |> helpers.parse_int)
      "R" -> Right(distance |> helpers.parse_int)

      other -> panic as { "invalid direction " <> other }
    }
  })
}

pub type State {
  State(at: Int, times_at_zero: Int)
}

pub fn pt_1(input: List(Op)) {
  use State(at:, times_at_zero:), op <- list.fold(input, State(50, 0))
  let distance = case op {
    Left(distance:) -> -distance
    Right(distance:) -> distance
  }

  let at = case at + distance {
    underflow if underflow < 0 -> 100 - underflow
    overflow if overflow > 99 -> -1 + overflow

    otherwise -> otherwise
  }

  let times_at_zero = case at {
    0 -> times_at_zero + 1
    _ -> times_at_zero
  }

  State(at:, times_at_zero:) |> echo
}

pub fn pt_2(input: List(Op)) {
  todo as "part 2 not implemented"
}
