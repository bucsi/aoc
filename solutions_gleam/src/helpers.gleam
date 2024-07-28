import gleam/dict.{type Dict}
import gleam/int

import gleam/io

import glearray.{type Array}

pub fn parse_int(from s: String) -> Int {
  case int.parse(s) {
    Ok(i) -> i
    Error(Nil) -> panic
  }
}

pub fn get(from d: Dict(String, a), key key: String) -> a {
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
