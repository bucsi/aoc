import aoc_2025/day_5
import gleam/list
import gleam/string

pub fn part2_testcases_test() {
  use #(test_name, input, expected) <- list.each([
    #("single range", ["3-5"], 3),
    #("simple overlapping range with switched order", ["7-9", "1-3"], 6),
    #("simple overlapping range", ["1-3", "7-9"], 6),
    #("comlpex overlapping range with switched order", ["3-5", "2-6"], 5),
    #("complex overlapping range", ["2-6", "3-5"], 5),
    #("three touching ranges", ["1-3", "4-6", "7-9"], 9),
    #("three touching ranges", ["1-3", "4-6", "7-9"], 9),
    #("with shared bound", ["1-3", "3-6"], 6),
    #("end is a new range", ["1-3", "7-9"], 6),
    #("equal ranges", ["1-3", "1-3"], 3),
  ])
  let result =
    { input |> string.join("\n") <> "\n\nirrelevant" }
    |> day_5.pt_2

  assert result == expected as test_name
}
