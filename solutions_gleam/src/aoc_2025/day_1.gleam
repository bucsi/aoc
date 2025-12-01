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
  {
    use State(at:, times_at_zero:), op <- list.fold(input, State(50, 0))
    let currently_at = at
    let current_times_at_zero = times_at_zero
    let at = at |> rotate_dial(op)

    let times_at_zero = case at {
      0 -> times_at_zero + 1
      _ -> times_at_zero
    }

    case at < 0 || at > 99 {
      True ->
        panic as {
          "Dial rotated out of bounds to "
          <> int.to_string(at)
          <> " by rotating from "
          <> int.to_string(currently_at)
          <> "by"
          <> case op {
            Left(distance:) -> " Left " <> int.to_string(distance)
            Right(distance:) -> " Right " <> int.to_string(distance)
          }
        }
      _ -> Nil
    }

    State(at:, times_at_zero:)
  }.times_at_zero
}

pub fn rotate_dial(starting_position at: Int, rotation op: Op) -> Int {
  let distance =
    case op {
      Left(distance:) -> -distance
      Right(distance:) -> distance
    }
    % 100

  case at + distance {
    overflow if overflow > 99 -> overflow - 100
    underflow if underflow < 0 -> underflow + 100
    otherwise -> otherwise
  }
}

pub fn pt_2(input: List(Op)) {
  todo as "part 2 not implemented"
}
