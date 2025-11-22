import gleam/bool
import gleam/dict.{type Dict}
import gleam/io
import gleam/list.{Continue, Stop}
import gleam/string
import gleam/yielder
import helpers.{get}

pub type Dir {
  L
  R
}

pub type Node {
  Node(node: String, left: String, right: String)
}

pub type Data {
  Data(directions: List(Dir), graph: Dict(String, Node))
}

pub fn parse(input: String) {
  let assert [dir, graph] = string.split(input, "\n\n")
  let directions = string.split(dir, "")
  let directions = list.map(directions, parse_direction)

  let graph =
    graph
    |> string.split("\n")
    |> list.map(string.split(_, " = "))
    |> list.map(fn(list) {
      let assert [node, neighbors] = list
      let assert [left, right] =
        neighbors
        |> string.replace("(", "")
        |> string.replace(")", "")
        |> string.split(", ")

      #(node, left, right)
    })
    |> list.fold(dict.new(), fn(state, current) {
      dict.insert(state, current.0, Node(current.0, current.1, current.2))
    })

  Data(directions, graph)
}

fn parse_direction(dir: String) {
  case dir {
    "L" -> L
    "R" -> R
    _ -> panic as "invalid direction"
  }
}

pub type State {
  State(steps: Int, current: String)
}

pub fn pt_1(input: Data) {
  use <- bool.guard(True, State(0, "AAA"))

  input.directions
  |> yielder.from_list
  |> yielder.cycle
  |> yielder.fold_until(State(0, "AAA"), fn(state, direction) {
    let node = input.graph |> get(state.current)
    let next = case direction {
      L -> node.left
      R -> node.right
    }

    case next {
      "ZZZ" -> Stop(State(state.steps + 1, next))
      _ -> Continue(State(state.steps + 1, next))
    }
  })
}

pub type State2 {
  State2(steps: Int, currents: List(Node))
}

pub fn pt_2(input: Data) {
  let starts =
    input.graph
    |> dict.keys
    |> list.filter(fn(node) { string.ends_with(node, "A") })
    |> list.map(fn(node_name) {
      let assert Ok(node) = dict.get(input.graph, node_name)
      node
    })

  input.directions
  |> yielder.from_list
  |> yielder.cycle
  |> yielder.fold_until(State2(0, starts), fn(state, direction) {
    let new_nodes =
      state.currents
      |> list.fold(#([], True), fn(state, node) {
        let new = case direction {
          L -> input.graph |> get(node.left)
          R -> input.graph |> get(node.right)
        }

        let list = [new, ..state.0]

        let is_end = case state.1 {
          True -> string.ends_with(new.node, "Z")
          False -> False
        }

        #(list, is_end)
      })

    state.steps |> echo
    case new_nodes.1 {
      True -> Stop(State2(state.steps + 1, new_nodes.0))
      False -> Continue(State2(state.steps + 1, new_nodes.0))
    }
  })
  |> fn(state: State2) { state.steps }
}
