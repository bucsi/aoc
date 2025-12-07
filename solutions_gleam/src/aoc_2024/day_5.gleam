import gleam/dict
import gleam/int
import gleam/list
import gleam/string
import helpers

pub type Rule =
  fn(dict.Dict(Int, Int)) -> Bool

pub type Updates {
  Updates(
    page_to_index: dict.Dict(Int, Int),
    index_to_page: dict.Dict(Int, Int),
  )
}

pub fn pt_1(input: String) {
  let assert [rules, updates] = input |> string.split("\n\n")
    as "rules and updates from file"

  let rules =
    rules
    |> string.split("\n")
    |> list.map(string.split(_, "|"))
    |> list.fold([], fn(rules, items) {
      let assert [earlier, later] = items as "earlier and later rule number"
      let earlier = helpers.parse_int(earlier)
      let later = helpers.parse_int(later)

      [make_rule(earlier, later), ..rules]
    })

  let updates =
    updates
    |> string.split("\n")
    |> list.map(string.split(_, ","))
    |> list.map(list.index_fold(
      _,
      Updates(dict.new(), dict.new()),
      parse_updates,
    ))

  list.map(updates, fn(update) {
    list.map(rules, fn(rule) { rule(update.page_to_index) })
    |> list.all(fn(val) { val == True })
    |> fn(is_correct) {
      case is_correct {
        True -> get_middle_page(update.index_to_page)
        _ -> 0
      }
    }
  })
  |> int.sum
}

fn get_middle_page(index_to_page: dict.Dict(Int, Int)) {
  let assert Ok(max_index) = index_to_page |> dict.keys |> list.max(int.compare)
  let middle_index = max_index / 2
  let assert Ok(page) = index_to_page |> dict.get(middle_index) as "middle page"
  page
}

fn parse_updates(updates, item, index) -> Updates {
  let page = item |> helpers.parse_int
  let Updates(page_to_index:, index_to_page:) = updates
  let page_to_index = page_to_index |> dict.insert(page, index)
  let index_to_page = index_to_page |> dict.insert(index, page)
  Updates(page_to_index:, index_to_page:)
}

fn make_rule(earlier: Int, later: Int) -> Rule {
  fn(dict) {
    // echo #("getting earlier:", earlier, "and later", later, "from dict:", dict)
    let earlier_index = dict |> dict.get(earlier)
    let later_index = dict |> dict.get(later)

    case earlier_index, later_index {
      Ok(e), Ok(l) -> e < l
      _, _ -> True
    }
  }
}

pub fn pt_2(_input: String) {
  "todo"
}
