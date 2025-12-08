import gleam/dict
import gleam/float
import gleam/int
import gleam/list
import gleam/string

import glanoid

import helpers/unsafe_float
import helpers/unsafe_int

pub type Coord3d {
  Coord3d(x: Int, y: Int, z: Int)
}

fn build_coord_3d(from: List(Int)) -> Coord3d {
  let assert [x, y, z] = from
  Coord3d(x, y, z)
}

pub fn pt_1(input: String) {
  let assert Ok(nanoid_generator) =
    glanoid.make_generator(glanoid.default_alphabet)
  let nanoid = fn() { nanoid_generator(4) }

  let coords = {
    use line <- list.map(string.split(input, "\n"))
    {
      use number <- list.map(string.split(line, ","))
      number |> unsafe_int.parse
    }
    |> build_coord_3d
  }

  {
    use #(p, q) <- list.map(list.combination_pairs(coords))
    #(#(p, q), distance(p, q))
  }
  |> list.sort(fn(a, b) { a.1 |> float.compare(b.1) })
  |> list.take(10)
  |> list.fold(dict.new(), fn(state, curr) {
    let #(#(p, q), d) = curr
    echo #("handling", p, "and", q, "their distance being", d)
    case state |> dict.get(p), state |> dict.get(q) {
      Error(Nil), Error(Nil) -> state |> new_circuit(p, q, nanoid)
      Ok(id), Error(Nil) -> state |> dict.insert(p, id)
      Error(Nil), Ok(id) -> state |> dict.insert(q, id)
      Ok(id), Ok(id2) if id == id2 -> state
      Ok(id), Ok(id2) -> panic as "both points already on different circuits"
    }
  })
  |> dict.to_list
  |> list.chunk(fn(tpl) { tpl.1 })
  |> list.map(list.length)
}

fn new_circuit(
  in state: dict.Dict(Coord3d, String),
  p p: Coord3d,
  q q: Coord3d,
  using nanoid: fn() -> String,
) -> dict.Dict(Coord3d, String) {
  let id = nanoid()
  state |> dict.insert(p, id) |> dict.insert(q, id)
}

pub fn distance(p: Coord3d, q: Coord3d) {
  unsafe_float.square_root(
    unsafe_int.square(p.x - q.x)
    +. unsafe_int.square(p.y - q.y)
    +. unsafe_int.square(p.z - q.z),
  )
}

pub fn pt_2(input: String) {
  todo as "part 2 not implemented"
}
