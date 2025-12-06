import gleam/dict
import gleam/int
import gleam/list
import gleam/regexp
import gleam/result
import gleam/string

import helpers.{Coord}
import helpers/unsafe_list

pub type HomeworkItem {
  Number(value: Int)
  Add
  Multiply
}

pub fn pt_1(input: String) {
  let assert Ok(hw_item_re) =
    regexp.compile("\\d+|\\+|\\*", regexp.Options(False, False))

  let #(homework, rows, cols) = {
    use #(dict, row, col), line, i <- list.index_fold(
      input |> string.split("\n"),
      #(dict.new(), 0, 0),
    )
    use #(dict, _, _), match, j <- list.index_fold(
      line |> regexp.scan(hw_item_re, _),
      #(dict, row, col),
    )
    #(
      match.content
        |> parse_homework_item
        |> dict.insert(dict, Coord(i, j), _),
      i,
      j,
    )
  }

  {
    use col <- list.map(list.range(0, cols))
    let operation = get_col_operation(homework, col, rows)
    get_col_values(homework, col, rows) |> list.reduce(operation)
  }
  |> result.values
  |> int.sum
}

fn get_col_values(
  dict: dict.Dict(helpers.Coord(Int), HomeworkItem),
  col: Int,
  max_rows: Int,
) -> List(Int) {
  use row <- list.map(list.range(0, max_rows - 1))
  let assert Ok(Number(value:)) = dict |> dict.get(Coord(row, col))
  value
}

fn get_col_operation(
  dict: dict.Dict(helpers.Coord(Int), HomeworkItem),
  col: Int,
  max_rows: Int,
) -> fn(Int, Int) -> Int {
  case dict |> dict.get(Coord(max_rows, col)) {
    Ok(Add) -> int.add
    Ok(Multiply) -> int.multiply
    _ -> panic as "unexpected item in dict"
  }
}

fn parse_homework_item(from: String) -> HomeworkItem {
  case from {
    "+" -> Add
    "*" -> Multiply
    string -> string |> helpers.parse_int |> Number
  }
}

pub fn pt_2(input: String) {
  let #(grid, rows, cols) = {
    use #(dict, row, col), line, current_row <- list.index_fold(
      input |> string.split("\n"),
      #(dict.new(), 0, 0),
    )
    use #(dict, _, _), char, current_col <- list.index_fold(
      line |> string.split(""),
      #(dict, row, col),
    )
    #(
      char |> dict.insert(dict, Coord(current_row, current_col), _),
      current_row,
      int.max(current_col, col),
    )
  }

  {
    use col <- list.map(list.range(0, cols))
    case get_col_operation_pt2(grid, col, rows) {
      Ok(operation) ->
        perform_operation_until_end_of_current_block(
          grid,
          col,
          rows,
          cols,
          operation,
        )
      Error(_) -> 0
    }
  }
  |> int.sum
}

fn perform_operation_until_end_of_current_block(
  grid,
  col,
  max_rows,
  max_cols,
  operation,
) {
  let #(running_sum, numbers_not_summed) = {
    use #(_, current_numbers), col <- list.fold_until(
      list.range(col, max_cols),
      #(0, []),
    )
    case get_line(grid, col, max_rows) {
      Error(_) ->
        list.Stop(#(current_numbers |> unsafe_list.reduce(operation), []))
      Ok(number) -> list.Continue(#(0, [number, ..current_numbers]))
    }
  }

  case numbers_not_summed |> list.reduce(operation) {
    Error(_) -> running_sum
    Ok(last_sum) -> running_sum + last_sum
  }
}

fn get_line(grid, col, max_rows) -> Result(Int, Nil) {
  {
    use row <- list.map(list.range(0, max_rows - 1))
    let assert Ok(value) = grid |> dict.get(Coord(row, col))
    value
  }
  |> string.join("")
  |> string.replace(" ", "")
  |> int.parse
}

fn get_col_operation_pt2(
  dict: dict.Dict(helpers.Coord(Int), String),
  col: Int,
  max_rows: Int,
) -> Result(fn(Int, Int) -> Int, Nil) {
  case dict |> dict.get(Coord(max_rows, col)) {
    Ok("+") -> Ok(int.add)
    Ok("*") -> Ok(int.multiply)
    _ -> Error(Nil)
  }
}
