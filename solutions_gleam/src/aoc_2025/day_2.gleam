import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import helpers

pub type Range {
  Range(start: Int, end: Int)
}

pub fn parse(input: String) {
  input
  |> string.split(",")
  |> list.map(string.split(_, "-"))
  |> list.map(fn(pairs) {
    let assert [start, end] = pairs as "after splitting range by -"
    let start = helpers.parse_int(start)
    let end = helpers.parse_int(end)

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

pub fn pt_2(input: List(Range)) {
  todo as "part 2 not implemented"
}
