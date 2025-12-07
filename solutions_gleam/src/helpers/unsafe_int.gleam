import gleam/int

pub fn parse(from s: String) -> Int {
  case int.parse(s) {
    Ok(i) -> i
    Error(Nil) -> panic
  }
}
