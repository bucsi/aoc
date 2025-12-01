import aoc_2025/day_1.{Left, Right, rotate_dial}

pub fn rotate_in_bounds_right_test() {
  let result = rotate_dial(50, Right(10))

  assert result == 60
}

pub fn rotate_in_bounds_left_test() {
  let result = rotate_dial(50, Left(10))

  assert result == 40
}

pub fn rotate_out_of_bounds_right_test() {
  let result = rotate_dial(50, Right(60))

  assert result == 10
}

pub fn rotate_out_of_bounds_left_test() {
  let result = rotate_dial(50, Left(60))

  assert result == 90
}

pub fn rotate_to_bound_left_test() {
  let result = rotate_dial(50, Left(50))

  assert result == 0
}

pub fn rotate_to_bound_right_test() {
  let result = rotate_dial(50, Right(50))

  assert result == 0
}

pub fn rotate_multiple_times() {
  let result = rotate_dial(25, Right(625))

  assert result == 25
}
