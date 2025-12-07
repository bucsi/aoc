pub fn unwrap(result: Result(a, b)) -> a {
  case result {
    Ok(v) -> v
    Error(_) -> panic
  }
}
