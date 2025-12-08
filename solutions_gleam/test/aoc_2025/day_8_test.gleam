import aoc_2025/day_8.{Coord3d, distance}
import gleam/list
import gleam/string

pub fn part1_testcases_test() {
  assert distance(Coord3d(162, 817, 812), Coord3d(425, 690, 689)) |> echo
    == distance(Coord3d(425, 690, 689), Coord3d(162, 817, 812))

  assert distance(Coord3d(162, 817, 812), Coord3d(425, 690, 689))
    <. distance(Coord3d(57, 618, 57), Coord3d(52, 470, 668)) |> echo
}
