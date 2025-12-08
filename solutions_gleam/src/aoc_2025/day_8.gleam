import gleam/dict
import gleam/float
import gleam/int
import gleam/list
import gleam/order
import gleam/string
import helpers/unsafe_result

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

pub fn parse(
  input: String,
) -> #(List(Coord3d), List(#(#(Coord3d, Coord3d), Float)), fn() -> String) {
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

  let coord_pairs = {
    use #(p, q) <- list.map(list.combination_pairs(coords))
    #(#(p, q), distance(p, q))
  }

  #(coords, coord_pairs, nanoid)
}

pub fn pt_1(
  input: #(List(Coord3d), List(#(#(Coord3d, Coord3d), Float)), fn() -> String),
) {
  let #(coords, coords_pairs, nanoid) = input

  coords_pairs
  |> list.sort(fn(a, b) { a.1 |> float.compare(b.1) })
  |> fn(pairs) {
    case coords |> list.length() < 1000 {
      True -> pairs |> list.take(10)
      False -> pairs |> list.take(1000)
    }
  }
  |> list.fold(dict.new(), fn(state, curr) {
    let #(#(p, q), _) = curr
    case state |> dict.get(p), state |> dict.get(q) {
      Error(Nil), Error(Nil) -> state |> new_circuit(p, q, nanoid)
      Ok(id), Error(Nil) -> state |> dict.insert(q, id)
      Error(Nil), Ok(id) -> state |> dict.insert(p, id)
      Ok(id), Ok(id2) if id == id2 -> state
      Ok(id), Ok(id2) -> state |> merge_circuits(id, id2)
    }
  })
  |> get_unique_circuits
  |> list.map(fn(tpl) { tpl.1 |> list.length })
  |> list.sort(int.compare |> order.reverse)
  |> list.take(3)
  |> list.reduce(int.multiply)
  |> unsafe_result.unwrap
}

fn get_unique_circuits(
  in state: dict.Dict(Coord3d, String),
) -> List(#(String, List(#(Coord3d, String)))) {
  state
  |> dict.to_list
  |> list.group(fn(tpl) { tpl.1 })
  |> dict.to_list
}

fn merge_circuits(
  in state: dict.Dict(Coord3d, String),
  change old_id: String,
  to new_id: String,
) -> dict.Dict(Coord3d, String) {
  use _, value <- dict.map_values(state)
  case value {
    id if id == old_id -> new_id
    _ -> value
  }
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

pub fn pt_2(
  input: #(List(Coord3d), List(#(#(Coord3d, Coord3d), Float)), fn() -> String),
) {
  let #(coords, coords_pairs, nanoid) = input

  coords_pairs
  |> list.sort(fn(a, b) { a.1 |> float.compare(b.1) })
  |> list.fold_until(
    #(
      coords
        |> list.map(fn(coord) { #(coord, nanoid()) })
        |> dict.from_list,
      Coord3d(0, 0, 0),
      Coord3d(0, 0, 0),
    ),
    fn(states, curr) {
      let #(state, _, _) = states
      let #(#(p, q), _) = curr
      let new_state = case state |> dict.get(p), state |> dict.get(q) {
        Ok(id), Ok(id2) if id == id2 -> state
        Ok(id), Ok(id2) -> state |> merge_circuits(id, id2)
        _, _ -> panic
      }

      case get_unique_circuits(new_state) |> list.length() {
        1 -> list.Stop(#(new_state, p, q))
        _ -> list.Continue(#(new_state, p, q))
      }
    },
  )
  |> fn(result) {
    let #(_, p, q) = result
    p.x * q.x
  }
}
