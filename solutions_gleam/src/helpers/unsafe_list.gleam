import gleam/list

pub fn reduce(over: List(a), with: fn(a, a) -> a) -> a {
  let assert Ok(val) = list.reduce(over, with)
  val
}
