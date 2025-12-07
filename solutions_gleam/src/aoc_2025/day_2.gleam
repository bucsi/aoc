import gleam/bool
import gleam/int
import gleam/list
import gleam/string

import helpers/unsafe_int

pub type Range {
  Range(start: Int, end: Int)
}

pub fn parse(input: String) {
  input
  |> string.split(",")
  |> list.map(string.split(_, "-"))
  |> list.map(fn(pairs) {
    let assert [start, end] = pairs as "after splitting range by -"
    let start = unsafe_int.parse(start)
    let end = unsafe_int.parse(end)

    Range(start:, end:)
  })
}

pub fn pt_1(ranges: List(Range)) {
  use running_sum, Range(start:, end:) <- list.fold(ranges, 0)
  use running_sum, current_number <- list.fold(
    list.range(start, end + 1),
    running_sum,
  )
  case current_number |> split_into_halves {
    Ok([first, second]) if first == second -> running_sum + current_number
    _ -> running_sum
  }
}

fn split_into_halves(current_number: Int) -> Result(List(String), Nil) {
  let str = current_number |> int.to_string
  let len = str |> string.length()

  use <- bool.guard(when: len % 2 == 1, return: Error(Nil))

  let mid_point = { len } / 2
  Ok([
    str |> string.slice(0, mid_point),
    str |> string.slice(mid_point, mid_point),
  ])
}

pub fn pt_2(ranges: List(Range)) {
  use running_sum, Range(start:, end:) <- list.fold(ranges, 0)
  use running_sum, current_number <- list.fold(
    list.range(start, end + 1),
    running_sum,
  )
  case
    current_number
    // |> echo as "\n\n====current number"
    |> split_into_groups
    |> list.any(fn(x) {
      does_pattern_repeat(x)
      // |> echo as "checking for repeating patterns"
    })
  {
    True -> {
      // echo current_number as "has repeating pattern"
      running_sum + current_number
    }
    _ -> running_sum
  }
}

fn split_into_groups(current_number: Int) -> List(List(List(String))) {
  let str = current_number |> int.to_string |> string.to_graphemes
  let len = str |> list.length()
  list.map(list.range(0, len + 1), fn(grouping) {
    str |> list.sized_chunk(grouping)
  })
  // |> echo as "splitting into groups"
}

fn does_pattern_repeat(parts: List(List(String))) -> Bool {
  use <- bool.guard(
    when: list.is_empty(parts) || list.length(parts) == 1,
    return: False,
  )
  let assert [pattern, ..parts] = parts
    as "getting first elem of grouping as pattern"
  use _, part <- list.fold_until(parts, True)
  case pattern == part {
    True -> {
      // echo #(pattern, part, "==", pattern == part) as "found repeating pattern"
      list.Continue(True)
    }
    _ -> list.Stop(False)
  }
}
