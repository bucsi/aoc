import gleam/int
import gleam/list
import gleam/string

import helpers/unsafe_int

pub type Race {
  Race(duration: Int, distance: Int)
}

fn make_race(touple: #(Int, Int)) -> Race {
  let #(fst, snd) = touple
  Race(fst, snd)
}

fn split_on_colon(each) {
  let assert [_title, nums] = string.split(each, ":")
  nums
}

fn parse_numbers(line: String) {
  string.split(line, " ")
  |> list.filter(keep_non_empty)
  |> list.map(unsafe_int.parse)
}

fn keep_non_empty(n) {
  case n {
    "" -> False
    _ -> True
  }
}

pub fn pt_1(input: String) {
  let assert [time, distance] =
    input
    |> string.split("\n")
    |> list.map(split_on_colon)
    |> list.map(parse_numbers)

  list.zip(time, distance)
  |> list.map(make_race)
  |> list.map(count_possible_wins)
  |> int.product
}

fn count_possible_wins(race: Race) -> Int {
  list.range(1, race.duration)
  |> list.map(fn(hold) {
    let speed = calculate_speed(hold)
    let distance = calculate_travel(race.duration - hold, speed)
    case distance > race.distance {
      True -> 1
      False -> 0
    }
  })
  |> int.sum
}

fn calculate_speed(time) {
  time
}

fn calculate_travel(remaining_time, speed) {
  remaining_time * speed
}

pub fn pt_2(input: String) {
  let assert [time, distance] =
    input
    |> string.replace(" ", "")
    |> string.replace("Time:", "")
    |> string.replace("Distance:", "")
    |> string.split("\n")

  count_possible_wins(Race(unsafe_int.parse(time), unsafe_int.parse(distance)))
}
