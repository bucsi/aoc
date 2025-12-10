import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import helpers/unsafe_float
import helpers/unsafe_int
import helpers/unsafe_list
import input

import helpers.{Coord, get_x, get_y}

fn build_coord(from: List(Int)) -> helpers.Coord(Int) {
  let assert [x, y] = from
  Coord(x, y)
}

pub fn parse(input: String) {
  use line <- list.map(string.split(input, "\n"))
  {
    use number <- list.map(string.split(line, ","))
    number |> unsafe_int.parse
  }
  |> build_coord
}

pub fn pt_1(input: List(helpers.Coord(Int))) {
  use max_area, #(a, b) <- list.fold(list.combination_pairs(input), 0)
  case { rectangle_side_a(a, b) + 1 } * { rectangle_side_b(a, b) + 1 } {
    area if area > max_area -> area
    _ -> max_area
  }
}

pub fn rectangle_side_a(p: helpers.Coord(Int), q: helpers.Coord(Int)) {
  int.absolute_value(p.x - q.x)
}

pub fn rectangle_side_b(p: helpers.Coord(Int), q: helpers.Coord(Int)) {
  int.absolute_value(p.y - q.y)
}

pub fn pt_2(input: List(helpers.Coord(Int))) {
  let min_x = input |> list.map(get_x) |> unsafe_list.reduce(int.min)
  let max_x = input |> list.map(get_x) |> unsafe_list.reduce(int.max)
  let min_y = input |> list.map(get_y) |> unsafe_list.reduce(int.min)
  let max_y = input |> list.map(get_y) |> unsafe_list.reduce(int.max)

  let tilemap =
    build_tilemap(min_x, max_x, min_y, max_y)
    |> add_red_tiles(input)
    |> add_green_tiles_vertical(min_x, max_x, min_y, max_y)
    |> fn(tpl) { tpl.0 }
    |> add_green_tiles_horizontal(min_x, max_x, min_y, max_y)
    |> fn(tpl) { tpl.0 }
    |> grid_to_string(min_x, max_x, min_y, max_y)
    |> io.println
}

pub type Tile {
  White
  Red
  Green
}

fn grid_to_string(tilemap, row_start, row_end, col_start, col_end) {
  {
    use row <- list.map(list.range(row_start, row_end))
    {
      use col <- list.map(list.range(col_start, col_end))
      case tilemap |> dict.get(Coord(row, col)) {
        Ok(White) -> "."
        Ok(Green) -> "X"
        Ok(Red) -> "#"
        _ -> panic
      }
    }
    |> string.join(" ")
  }
  |> string.join("\n")
}

fn add_green_tiles_vertical(tilemap, row_start, row_end, col_start, col_end) {
  use #(tilemap, paint), row <- list.fold(list.range(row_start, row_end), #(
    tilemap,
    White,
  ))
  echo #("new line, paint is", paint)
  use #(tilemap, paint), col <- list.fold(list.range(col_start, col_end), #(
    tilemap,
    paint,
  ))
  let coord = Coord(row, col)
  let old = tilemap |> dict.get(coord)
  #(coord, tilemap |> dict.get(coord), paint)
  |> echo
  let #(tilemap, paint) = case tilemap |> dict.get(coord), paint {
    Ok(White), White -> #(tilemap, paint)
    Ok(White), Green -> #(tilemap |> dict.insert(coord, paint), paint)
    Ok(Red), White | Ok(Green), White -> #(tilemap, Green)
    Ok(Red), Green | Ok(Green), Green -> #(tilemap, White)
    ot, her -> {
      echo #(ot, her)
      panic
    }
  }
  #(coord, tilemap |> dict.get(coord), paint) |> echo
  tilemap
  |> grid_to_string(row_start, row_end, col_start, col_end)
  |> io.println

  io.println("-------------------------")
  let assert Ok(_) = input.input("")

  #(tilemap, paint)
}

fn add_green_tiles_horizontal(tilemap, row_start, row_end, col_start, col_end) {
  use #(tilemap, paint), col <- list.fold(list.range(col_start, col_end), #(
    tilemap,
    White,
  ))
  echo #("new line, paint is", paint)
  // here is the bug: for some reason at the start of iteration paing is Green
  // idea: collect verticals / horizontals as a list, chunk them by color
  // [. . . # X X . . X . .] |> chunk(by: fn(n) { n % 2 })
  // -> [[. . .], [#], [X X], [. .], [X] [. .]]
  // then take until it's not a list of white
  // then drop until it's not a list of white
  // set the rest to green
  // use In/Out instead of green
  use #(tilemap, paint), row <- list.fold(list.range(row_start, row_end), #(
    tilemap,
    paint,
  ))
  let coord = Coord(row, col)
  #(coord, tilemap |> dict.get(coord), paint) |> echo
  let #(tilemap, paint) = case tilemap |> dict.get(coord), paint {
    Ok(White), White -> #(tilemap, paint)
    Ok(White), Green -> #(tilemap |> dict.insert(coord, paint), paint)
    Ok(Red), White | Ok(Green), White -> #(tilemap, Green)
    Ok(Red), Green | Ok(Green), Green -> #(tilemap, White)
    ot, her -> {
      echo #(coord, ot, her)
      panic
    }
  }
  #(coord, tilemap |> dict.get(coord), paint) |> echo
  tilemap
  |> grid_to_string(row_start, row_end, col_start, col_end)
  |> io.println

  io.println("-------------------------")
  let assert Ok(_) = input.input("")

  #(tilemap, paint)
}

fn add_red_tiles(tilemap, red_tiles) {
  red_tiles
  |> list.fold(tilemap, fn(tilemap, tile) { tilemap |> dict.insert(tile, Red) })
}

fn build_tilemap(row_start, row_end, col_start, col_end) {
  use tilemap, row <- list.fold(list.range(row_start, row_end), dict.new())
  use tilemap, col <- list.fold(list.range(col_start, col_end), tilemap)
  tilemap |> dict.insert(Coord(row, col), White)
}

fn min_x(left: helpers.Coord(Int), right: helpers.Coord(Int)) {
  left.x |> int.min(right.x)
}

fn min_y(left: helpers.Coord(Int), right: helpers.Coord(Int)) {
  left.y |> int.min(right.y)
}

fn max_x(left: helpers.Coord(Int), right: helpers.Coord(Int)) {
  left.x |> int.max(right.x)
}

fn max_y(left: helpers.Coord(Int), right: helpers.Coord(Int)) {
  left.y |> int.max(right.y)
}
