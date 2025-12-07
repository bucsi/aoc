import gleam/bool
import gleam/dict
import gleam/function
import gleam/int
import gleam/list
import gleam/result
import gleam/string

import helpers.{type Coord, Coord}

pub fn parse(input: String) {
  helpers.parse_grid(
    from: input,
    delimited_by: "\n",
    split_by: "",
    using: function.identity,
  )
}

pub fn pt_1(input: helpers.ParsedGrid(String)) {
  let helpers.GridResult(word_search, rows, cols) = input
  {
    use i <- list.map(list.range(0, rows))
    use j <- list.map(list.range(0, cols))
    // echo #(
    //   "Checking coords",
    //   #(i, j),
    //   "where the character is",
    //   dict.get(word_search, Coord(i, j)),
    // )
    [
      word_search |> horizontal(i, j),
      word_search |> vertical(i, j),
      word_search |> diagonal_down_right(i, j),
      word_search |> diagonal_down_left(i, j),
    ]
    |> list.map(count)
    // |> fn(r) {
    //   case r {
    //     [0, 0, 0, 0] -> r
    //     _ -> echo r
    //   }
    // }
  }
  |> list.flatten
  |> list.flatten
  |> int.sum
}

fn count(
  next4: #(
    Result(String, Nil),
    Result(String, Nil),
    Result(String, Nil),
    Result(String, Nil),
  ),
) -> Int {
  case next4 {
    #(Ok("X"), Ok("M"), Ok("A"), Ok("S"))
    | #(Ok("S"), Ok("A"), Ok("M"), Ok("X")) -> 1
    _ -> 0
  }
}

fn horizontal(
  word_search: dict.Dict(Coord(Int), String),
  row: Int,
  col: Int,
) -> #(
  Result(String, Nil),
  Result(String, Nil),
  Result(String, Nil),
  Result(String, Nil),
) {
  #(
    dict.get(word_search, Coord(row, col)),
    dict.get(word_search, Coord(row, col + 1)),
    dict.get(word_search, Coord(row, col + 2)),
    dict.get(word_search, Coord(row, col + 3)),
  )
}

fn vertical(
  word_search: dict.Dict(Coord(Int), String),
  row: Int,
  col: Int,
) -> #(
  Result(String, Nil),
  Result(String, Nil),
  Result(String, Nil),
  Result(String, Nil),
) {
  #(
    dict.get(word_search, Coord(row, col)),
    dict.get(word_search, Coord(row + 1, col)),
    dict.get(word_search, Coord(row + 2, col)),
    dict.get(word_search, Coord(row + 3, col)),
  )
}

fn diagonal_down_left(
  word_search: dict.Dict(Coord(Int), String),
  row: Int,
  col: Int,
) -> #(
  Result(String, Nil),
  Result(String, Nil),
  Result(String, Nil),
  Result(String, Nil),
) {
  #(
    dict.get(word_search, Coord(row, col)),
    dict.get(word_search, Coord(row + 1, col - 1)),
    dict.get(word_search, Coord(row + 2, col - 2)),
    dict.get(word_search, Coord(row + 3, col - 3)),
  )
}

fn diagonal_down_right(
  word_search: dict.Dict(Coord(Int), String),
  row: Int,
  col: Int,
) -> #(
  Result(String, Nil),
  Result(String, Nil),
  Result(String, Nil),
  Result(String, Nil),
) {
  #(
    dict.get(word_search, Coord(row, col)),
    dict.get(word_search, Coord(row + 1, col + 1)),
    dict.get(word_search, Coord(row + 2, col + 2)),
    dict.get(word_search, Coord(row + 3, col + 3)),
  )
}

pub fn pt_2(input: helpers.ParsedGrid(String)) {
  let helpers.GridResult(word_search, rows, cols) = input
  {
    use i <- list.map(list.range(0, rows))
    use j <- list.map(list.range(0, cols))
    case word_search |> dict.get(Coord(i, j)) {
      Ok("A") -> find_mas(word_search, i, j)
      _ -> 0
    }
  }
  |> list.flatten
  |> int.sum
}

fn find_mas(word_search: dict.Dict(Coord(Int), String), i: Int, j: Int) -> Int {
  // echo #(
  //   "[Part2] Checking",
  //   Coord(i, j),
  //   ", where char is",
  //   word_search |> dict.get(Coord(i, j)),
  // )
  let top_left = word_search |> dict.get(Coord(i - 1, j - 1))
  let bottom_left = word_search |> dict.get(Coord(i + 1, j - 1))
  let top_right = word_search |> dict.get(Coord(i - 1, j + 1))
  let bottom_right = word_search |> dict.get(Coord(i + 1, j + 1))

  use <- bool.guard(
    when: [top_left, bottom_left, top_right, bottom_right]
      |> list.any(result.is_error),
    return: 0,
  )

  let assert Ok(top_left) = top_left
  let assert Ok(top_right) = top_right
  let assert Ok(bottom_left) = bottom_left
  let assert Ok(bottom_right) = bottom_right

  let assert [pair_0_0, pair_0_1] =
    [top_left, bottom_right] |> list.sort(string.compare)
  let assert [pair_1_0, pair_1_1] =
    [bottom_left, top_right] |> list.sort(string.compare)

  case pair_0_0, pair_0_1, pair_1_0, pair_1_1 {
    "M", "S", "M", "S" -> 1
    _, _, _, _ -> 0
  }
}
