import gleam/int
import gleam/list
import gleam/string
import helpers/unsafe_float
import helpers/unsafe_int

import helpers.{Coord}

fn build_coord(from: List(Int)) -> helpers.Coord(Int) {
  let assert [x, y] = from
  Coord(x, y)
}

pub fn parse(input: String) {
  use line <- list.map(string.split(input, "\n"))
  {
    use number <- list.map(string.split(line, ","))
    number |> unsafe_int.parse
  }
  |> build_coord
}

pub fn pt_1(input: List(helpers.Coord(Int))) {
  use max_area, #(a, b) <- list.fold(list.combination_pairs(input), 0)
  case { rectangle_side_a(a, b) + 1 } * { rectangle_side_b(a, b) + 1 } {
    area if area > max_area -> area
    _ -> max_area
  }
}

pub fn rectangle_side_a(p: helpers.Coord(Int), q: helpers.Coord(Int)) {
  int.absolute_value(p.x - q.x)
}

pub fn rectangle_side_b(p: helpers.Coord(Int), q: helpers.Coord(Int)) {
  int.absolute_value(p.y - q.y)
}

pub fn pt_2(input: List(helpers.Coord(Int))) {
  todo as "part 2 not implemented"
}
