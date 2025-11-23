import gleam/int
import gleam/list
import gleam/option
import gleam/regexp
import helpers

fn regexp_options(multiline multi_line: Bool) {
  regexp.Options(case_insensitive: False, multi_line:)
}

const mul_pattern = "mul\\((\\d+),(\\d+)\\)"

pub fn pt_1(input: String) {
  input |> count_muls
}

fn count_muls(input: String) -> Int {
  let assert Ok(pattern) = regexp.compile(mul_pattern, regexp_options(False))
    as "Regexp compile failed"
  input
  |> regexp.scan(pattern, _)
  |> list.map(fn(match: regexp.Match) {
    let assert regexp.Match(_, [option.Some(left), option.Some(right)]) = match
    let left_int = helpers.parse_int(left)
    let right_int = helpers.parse_int(right)
    left_int * right_int
  })
  |> int.sum
}

pub fn pt_2(input: String) {
  let assert Ok(dont_pattern) =
    regexp.compile("don't\\(\\)[^d]*do\\(\\)", regexp_options(True))
    as "Regexp compile failed"

  let assert Ok(dont_pattern_end_of_file) =
    regexp.compile("don't\\(\\)[^d]*$", regexp_options(True))
    as "Regexp compile failed"

  input
  |> regexp.replace(dont_pattern, _, "")
  |> echo
  |> regexp.replace(dont_pattern_end_of_file, _, "")
  |> echo
  |> count_muls
}
