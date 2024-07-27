import gleam/dict.{type Dict}
import gleam/int

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
