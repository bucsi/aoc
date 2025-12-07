import gleam/list
import gleam/string

import helpers/unsafe_int

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
      "L" -> Left(distance |> unsafe_int.parse)
      "R" -> Right(distance |> unsafe_int.parse)

      other -> panic as { "invalid direction " <> other }
    }
  })
}

pub type State {
  State(at: Int, times_at_zero: Int)
}

pub fn pt_1(input: List(Op)) {
  {
    use state, op <- list.fold(input, State(50, 0))
    let State(at:, times_at_zero:) = state
    let at = at |> rotate_dial(op)

    let times_at_zero = case at {
      0 -> times_at_zero + 1
      _ -> times_at_zero
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
  {
    use State(at:, times_at_zero:), op <- list.fold(input, State(50, 0))
    let #(at, passed_over_zero) = at |> rotate_dial_pt2_dumb(op)
    let times_at_zero = times_at_zero + passed_over_zero
    State(at:, times_at_zero:)
  }.times_at_zero
}

pub fn rotate_dial_pt2_dumb(
  starting_position at: Int,
  rotation op: Op,
) -> #(Int, Int) {
  let distance = op.distance
  let step = case op {
    Left(_) -> -1
    Right(_) -> 1
  }

  use #(currently_at, passed_over_zero), _ <- list.fold(
    list.range(0, distance - 1),
    #(at, 0),
  )

  let new_pos = case currently_at + step {
    overflow if overflow > 99 -> 0
    underflow if underflow < 0 -> 99
    otherwise -> otherwise
  }

  let passed_over_zero = case new_pos {
    0 -> passed_over_zero + 1
    _ -> passed_over_zero
  }

  #(new_pos, passed_over_zero)
}

pub fn rotate_dial_pt2(
  starting_position at: Int,
  rotation op: Op,
) -> #(Int, Int) {
  let old_at = at
  let full_rotations = get_distance_from_operation(op) / 100

  let relevant_distance =
    case op {
      Left(distance:) -> -distance
      Right(distance:) -> distance
    }
    % 100

  let #(new_position, passed_over_zero) = case at + relevant_distance {
    overflow if overflow > 99 && at != 99 -> #(overflow - 100, 1)
    underflow if underflow < 0 && at != 0 -> #(underflow + 100, 1)
    overflow if overflow > 99 -> #(overflow - 100, 0)
    underflow if underflow < 0 -> #(underflow + 100, 0)
    0 -> #(0, 1)
    otherwise -> #(otherwise, 0)
  }

  echo #(
    "starting at",
    old_at,
    "operation",
    op,
    "relevant_distance",
    relevant_distance,
    "full_rotations",
    full_rotations,
    "passed_over_zero",
    passed_over_zero,
    "ended up at",
    new_position,
  )

  #(new_position, { full_rotations + passed_over_zero }) |> echo
}

fn get_distance_from_operation(op: Op) -> Int {
  case op {
    Left(distance:) -> distance
    Right(distance:) -> distance
  }
}
