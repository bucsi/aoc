import gleam/float

pub fn square_root(x: Float) -> Float {
  case float.square_root(x) {
    Ok(x) -> x
    Error(Nil) -> panic
  }
}
