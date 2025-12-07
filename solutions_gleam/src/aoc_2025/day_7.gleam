import gleam/bool
import gleam/dict
import gleam/list
import gleam/option

import helpers.{Coord}

pub type BeamKind {
  Pt1
  Pt2(value: Int)
}

pub type Cell {
  Splitter
  Empty
  Beam(BeamKind)
}

pub fn pt_1(input: helpers.ParsedGrid(Cell)) {
  let helpers.GridResult(manifold, rows:, cols:) = input
  // manifold |> print_manifold(rows, cols) |> io.println
  {
    use state, row <- list.fold(list.range(0, rows), #(0, manifold))
    let #(_split_count, _manifold) = state
    use <- bool.guard(when: row > rows, return: state)
    // manifold |> print_manifold(rows, cols) |> io.println
    // io.println("-------------------------------")
    use #(split_count, manifold), col <- list.fold(list.range(0, cols), state)
    case manifold |> dict.get(Coord(row, col)) {
      Ok(Beam(_)) -> #(
        split_count,
        manifold
          |> dict.upsert(Coord(row + 1, col), fn(value) {
            case value {
              option.Some(Splitter) -> Splitter
              _ -> Beam(Pt1)
            }
          }),
      )
      Ok(Splitter) ->
        case manifold |> dict.get(Coord(row - 1, col)) {
          Ok(Beam(_)) -> #(
            split_count + 1,
            manifold
              |> dict.insert(Coord(row + 1, col - 1), Beam(Pt1))
              |> dict.insert(Coord(row + 1, col + 1), Beam(Pt1)),
          )
          _ -> #(split_count, manifold)
        }
      _ -> #(split_count, manifold)
    }
  }.0
}

// fn print_manifold(manifold, rows, cols) {
//   {
//     use row <- list.map(list.range(0, rows))
//     {
//       use col <- list.map(list.range(0, cols))
//       case manifold |> dict.get(Coord(row, col)) {
//         Ok(Beam(Pt1)) -> "|"
//         Ok(Beam(Pt2(value:))) -> {
//           value |> int.to_base36
//         }
//         Ok(Empty) -> "."
//         Ok(Splitter) -> "^"
//         _ -> panic as "unexpected cell in manifold"
//       }
//     }
//     |> string.join("")
//   }
//   |> string.join("\n")
// }

pub fn parse(input: String) -> helpers.ParsedGrid(Cell) {
  use c <- helpers.parse_grid(from: input, delimited_by: "\n", split_by: "")
  case c {
    "^" -> Splitter
    "." -> Empty
    "S" -> Beam(Pt2(1))
    _ -> panic as "unexpected cell when parsing initial manifold"
  }
}

pub fn pt_2(input: helpers.ParsedGrid(Cell)) {
  let helpers.GridResult(manifold, rows:, cols:) = input

  let manifold = {
    use state, row <- list.fold(list.range(0, rows), manifold)
    let manifold = state
    use <- bool.guard(when: row > rows, return: state)
    // manifold |> print_manifold(rows, cols) |> io.println
    // io.println("-------------------------------")
    use manifold, col <- list.fold(list.range(0, cols), manifold)
    case manifold |> dict.get(Coord(row, col)) {
      Ok(Beam(Pt2(value:))) ->
        manifold
        |> dict.upsert(Coord(row + 1, col), upsert_cell(_, value))

      Ok(Splitter) ->
        case manifold |> dict.get(Coord(row - 1, col)) {
          Ok(Beam(Pt2(value:))) ->
            manifold
            |> dict.upsert(Coord(row + 1, col - 1), upsert_cell(_, value))
            |> dict.upsert(Coord(row + 1, col + 1), upsert_cell(_, value))

          _ -> manifold
        }
      _ -> manifold
    }
  }

  use sum, col <- list.fold(list.range(0, cols), 0)
  case manifold |> dict.get(Coord(rows, col)) {
    Ok(Beam(Pt2(value:))) -> sum + value
    _ -> sum
  }
}

fn upsert_cell(cell: option.Option(Cell), previous value: Int) -> Cell {
  case cell {
    option.Some(Splitter) -> Splitter
    option.Some(Beam(Pt2(value2))) -> Beam(Pt2(value + value2))
    option.Some(Empty) | option.None -> Beam(Pt2(value))

    otherwise -> {
      echo #(otherwise, value)
      panic
    }
  }
}
