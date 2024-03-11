import gleam/string.{split}
import gleam/list.{first, last, map}
import gleam/result.{unwrap, values}
import gleam/int

pub fn pt_1(input: String) {
  input
  |> split("\n")
  |> map(split(_, ""))
  |> map(get_numbers)
  |> map(first_and_last_digit_to_two_digit_number)
  |> int.sum
}

fn get_numbers(line: List(String)) -> List(Int) {
  line
  |> map(int.parse)
  |> values
}

fn first_and_last_digit_to_two_digit_number(numbers: List(Int)) -> Int {
  let tens = unwrap(first(numbers), 0) * 10
  let ones = unwrap(last(numbers), 0)

  tens + ones
}

pub fn pt_2(input: String) {
  todo as "part 2 not implemented"
}
