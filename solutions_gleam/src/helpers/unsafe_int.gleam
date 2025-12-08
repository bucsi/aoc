import gleam/int

pub fn parse(from s: String) -> Int {
  case int.parse(s) {
    Ok(i) -> i
    Error(Nil) -> panic
  }
}

pub fn square_root(x: Int) -> Float {
  case int.square_root(x) {
    Ok(x) -> x
    Error(Nil) -> panic
  }
}

pub fn power(base: Int, of exponent: Float) {
  case int.power(base, exponent) {
    Ok(x) -> x
    Error(Nil) -> panic
  }
}

pub fn square(base: Int) {
  power(base, 2.0)
}
