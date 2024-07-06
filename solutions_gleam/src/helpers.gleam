import gleam/int
import gleam/io

pub fn parse_int(from s: String) -> Int {
  case int.parse(s) {
    Ok(i) -> i
    Error(Nil) -> panic
  }
}
