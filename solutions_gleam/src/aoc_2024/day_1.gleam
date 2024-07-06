import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub fn pt_1(input: String) {
  input
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> list.map(list.map(_, int.parse))
  |> list.map(result.values)
  |> list.map(num_from_first_last_digits)
  |> int.sum
}

fn num_from_first_last_digits(nums: List(Int)) -> Int {
  let assert Ok(first) = list.first(nums)
  let assert Ok(last) = list.reduce(nums, fn(_, b) { b })

  10 * first + last
}

fn replace_char_to_int(s: String) -> String {
  s
  |> string.replace("one", "o1e")
  |> string.replace("two", "t2")
  |> string.replace("three", "t3e")
  |> string.replace("four", "4")
  |> string.replace("five", "5e")
  |> string.replace("six", "6")
  |> string.replace("seven", "7n")
  |> string.replace("eight", "e8t")
  |> string.replace("nine", "n9n")
}

pub fn pt_2(input: String) {
  input
  |> string.split("\n")
  |> list.map(replace_char_to_int)
  |> list.map(string.to_graphemes)
  |> list.map(list.map(_, int.parse))
  |> list.map(result.values)
  |> list.map(num_from_first_last_digits)
  |> int.sum
}
