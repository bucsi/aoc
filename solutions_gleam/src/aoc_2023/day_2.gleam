import gleam/int
import gleam/list
import gleam/string

import helpers.{parse_int}

pub type Game {
  Game(id: Int, rounds: List(Round))
}

pub type Round {
  Round(red: Int, green: Int, blue: Int)
}

fn parse_game(from: String) {
  let assert [name, rounds] = string.split(from, ": ")

  let assert [_game, id] = string.split(name, " ")
  let assert Ok(id) = int.parse(id)

  let rounds = string.split(rounds, "; ")
  let rounds = list.map(rounds, parse_round)

  Game(id, rounds)
}

fn parse_round(from: String) {
  from
  |> string.split(", ")
  |> list.map(string.split(_, " "))
  |> list.fold(Round(0, 0, 0), fn(r, i) {
    case i {
      [n, "red"] -> Round(..r, red: parse_int(n))
      [n, "green"] -> Round(..r, green: parse_int(n))
      [n, "blue"] -> Round(..r, blue: parse_int(n))
      _ -> panic
    }
  })
}

pub fn parse(input: String) -> List(Game) {
  input |> string.split("\n") |> list.map(parse_game)
}

fn is_possible(g: Game) -> Bool {
  g.rounds
  |> list.fold(True, fn(res, round) {
    res && round.red <= 12 && round.green <= 13 && round.blue <= 14
  })
}

pub fn pt_1(input: List(Game)) {
  input |> list.filter(is_possible) |> list.map(fn(g) { g.id }) |> int.sum
}

pub fn pt_2(input: List(Game)) {
  input
  |> list.map(get_minimum_required_colors)
  |> list.map(fn(r) { [r.red, r.green, r.blue] })
  |> list.map(int.product)
  |> int.sum
}

fn get_minimum_required_colors(g: Game) {
  g.rounds
  |> list.fold(Round(0, 0, 0), fn(r, round) {
    Round(
      int.max(r.red, round.red),
      int.max(r.green, round.green),
      int.max(r.blue, round.blue),
    )
  })
}
