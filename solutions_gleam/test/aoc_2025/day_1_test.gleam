import gleam/list

import aoc_2025/day_1.{Left, Right, rotate_dial_pt2_dumb}

pub fn test_rotate_dial_pt2_dumb_test() {
  use
    #(test_name, starting_position, rotation, #(expected_value, expected_zeros))
  <- list.each([
    #("rotate right within bounds", 5, Right(4), #(9, 0)),
    #("rotate left within bounds", 2, Left(1), #(1, 0)),
    #("rotate left with wrap around", 2, Left(5), #(97, 1)),
    #("rotate right with wrap around", 99, Right(4), #(3, 1)),
    #("rotate left full circle", 0, Left(100), #(0, 1)),
    #("rotate right full circle", 0, Right(100), #(0, 1)),
    #("rotate ten times", 1, Right(1000), #(1, 10)),
  ])
  assert rotate_dial_pt2_dumb(starting_position:, rotation:)
    == #(expected_value, expected_zeros)
    as test_name
}
