import gleam/int
import gleam/list
import gleam/string
import helpers.{parse_int}

pub fn parse(input: String) -> List(Elf) {
  input
  |> string.split("\n\n")
  |> list.map(string.split(_, "\n"))
  |> list.map(list.map(_, parse_int))
  |> list.map(int.sum)
  |> list.map(Elf)
  |> list.sort(fn(other, elf) { int.compare(elf.calories, other.calories) })
}

pub type Elf {
  Elf(calories: Int)
}

pub fn pt_1(input: List(Elf)) {
  input |> list.take(1) |> list.map(fn(e) { e.calories })
}

pub fn pt_2(input: List(Elf)) {
  input |> list.take(3) |> list.map(fn(e) { e.calories }) |> int.sum
}
