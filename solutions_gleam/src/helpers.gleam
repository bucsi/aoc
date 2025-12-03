import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{None, Some}

import glearray.{type Array}

pub type Coord(a) {
  Coord(x: a, y: a)
}

pub fn parse_int(from s: String) -> Int {
  case int.parse(s) {
    Ok(i) -> i
    Error(Nil) -> panic
  }
}

pub fn unwrap_result(result: Result(a, b)) -> a {
  case result {
    Ok(v) -> v
    Error(_) -> panic
  }
}

pub fn get(from d: Dict(k, v), key key: k) -> v {
  case dict.get(d, key) {
    Ok(v) -> v
    Error(_) -> panic
  }
}

pub fn at(array: Array(a), index: Int) -> a {
  let index = case index {
    _ if index < 0 -> 0
    i -> i
  }
  case glearray.get(array, index) {
    Ok(v) -> v
    Error(_) -> panic
  }
}

pub fn count_occurences(list: List(a)) -> Dict(a, Int) {
  list
  |> list.fold(dict.new(), fn(dict, elem) {
    dict.upsert(dict, elem, fn(value) {
      case value {
        Some(value) -> value + 1
        None -> 1
      }
    })
  })
}

pub fn eq(lhs, rhs) {
  lhs == rhs
}

pub fn undigits(numbers: List(Int), base: Int) -> Result(Int, Nil) {
  case base < 2 {
    True -> Error(Nil)
    False -> undigits_loop(numbers, base, 0)
  }
}

fn undigits_loop(numbers: List(Int), base: Int, acc: Int) -> Result(Int, Nil) {
  case numbers {
    [] -> Ok(acc)
    [digit, ..] if digit >= base -> Error(Nil)
    [digit, ..rest] -> undigits_loop(rest, base, acc * base + digit)
  }
}
