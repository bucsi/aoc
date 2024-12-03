import gleam/bool
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/order.{type Order}
import gleam/string

import helpers

pub fn parse(input: String) -> List(List(Int)) {
  input
  |> string.split("\n")
  |> list.map(string.split(_, " "))
  |> list.map(list.map(_, helpers.parse_int(_)))
}

pub fn pt_1(input: List(List(Int))) {
  use acc, row <- list.fold(input, 0)
  case is_safe(row) {
    True -> acc + 1
    False -> acc
  }
}

fn is_safe(row: List(Int)) -> Bool {
  let differences = get_differences(row)

  let order_ok =
    differences
    |> list.map(fn(n) { n > 0 })
    |> list.unique
    |> list.length
    |> helpers.eq(1)

  let change_ok =
    differences
    |> list.map(int.absolute_value)
    |> list.all(fn(n) { 1 <= n && n <= 3 })

  order_ok && change_ok
}

fn get_differences(row: List(Int)) -> List(Int) {
  row
  |> list.window_by_2
  |> list.map(fn(tpl) { tpl.0 - tpl.1 })
}

pub fn pt_2(input: List(List(Int))) {
  use acc, row <- list.fold(input, 0)
  case has_safe_version(row) {
    True -> acc + 1
    False -> acc
  }
}

fn has_safe_version(row: List(Int)) -> Bool {
  let length = list.length(row)
  [
    is_safe(row),
    ..list.map(list.range(0, length), fn(i) {
      is_valid_with_skip(row, i)
      |> fn(acc: Accumulator) { acc.valid }
    })
  ]
  |> list.any(fn(b) { b == True })
}

type Accumulator {
  Accumulator(previous: Option(Int), order: Option(Order), valid: Bool)
}

fn is_valid_with_skip(row: List(Int), skip: Int) -> Accumulator {
  list.index_fold(
    row,
    Accumulator(option.None, option.None, True),
    fn(acc, value, index) {
      use <- bool.guard(when: index == skip, return: acc)
      use <- bool.guard(when: !acc.valid, return: acc)
      case acc.previous {
        option.None -> first(acc, value)
        option.Some(_) -> nth(acc, value)
      }
    },
  )
}

fn first(acc: Accumulator, value: Int) -> Accumulator {
  Accumulator(option.Some(value), option.None, True)
}

fn second(acc: Accumulator, value: Int) -> Accumulator {
  let assert option.Some(prev) = acc.previous
  Accumulator(
    option.Some(prev),
    option.Some(int.compare(prev, value)),
    valid_diff(prev, value),
  )
}

fn valid_diff(a: Int, b: Int) -> Bool {
  a - b |> int.absolute_value |> fn(x) { 1 <= x && x <= 3 }
}

fn nth(acc: Accumulator, value: Int) -> Accumulator {
  case acc.order {
    option.None -> second(acc, value)
    option.Some(order) -> {
      let assert option.Some(prev) = acc.previous
      let new_order = int.compare(prev, value)

      let order_ok = order == new_order
      let change_ok = valid_diff(prev, value)

      case order_ok, change_ok {
        True, True -> Accumulator(Some(value), Some(order), True)
        _, _ -> Accumulator(Some(value), Some(order), False)
      }
    }
  }
}
