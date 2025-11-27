import gleam/dict
import gleam/list
import gleam/string
import helpers

pub type Rule =
  fn(dict.Dict(Int, Int)) -> Bool

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

      [get_rule(earlier, later), ..rules]
    })

  let updates =
    updates
    |> string.split("\n")
    |> list.map(string.split(_, ","))
    |> list.fold(dict.new(), fn(updates, items) {
      items
      |> list.map(helpers.parse_int)
      |> list.index_fold(updates, fn(dict, curr, i) {
        dict |> dict.insert(curr, i)
      })
    })
}

fn get_rule(earlier: Int, later: Int) -> fn(dict.Dict(Int, Int)) -> Bool {
  fn(dict) {
    let assert Ok(earlier_index) = dict |> dict.get(earlier)
    let assert Ok(later_index) = dict |> dict.get(later)

    earlier_index < later_index
  }
}

pub fn pt_2(input: String) {
  todo as "part 2 not implemented"
}
