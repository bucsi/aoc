import gleam/dict.{type Dict}

pub fn get(from d: Dict(k, v), key key: k) -> v {
  case dict.get(d, key) {
    Ok(v) -> v
    Error(_) -> panic
  }
}
