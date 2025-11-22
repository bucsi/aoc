import gleam/int
import gleam/list
import gleam/string
import gleam/yielder
import helpers.{parse_int}

pub type Maps {
  Maps(
    seed_to_soil: List(Map),
    soil_to_fertilizer: List(Map),
    fertilizer_to_water: List(Map),
    water_to_light: List(Map),
    light_to_temperature: List(Map),
    temperature_to_humidity: List(Map),
    humidity_to_location: List(Map),
  )
}

pub type Map {
  Map(destination_start: Int, source_start: Int, length: Int)
}

fn make_map(list) {
  let assert [d, s, l] = list
  Map(d, s, l)
}

fn make_maps(list) {
  let assert [a, b, c, d, e, f, g] = list
  Maps(a, b, c, d, e, f, g)
}

pub fn pt_1(input: String) {
  let assert [seeds, ..maps] = string.split(input, "\n\n")
  let assert [_, seeds] = string.split(seeds, ": ")
  let seeds = seeds |> string.split(" ") |> list.map(parse_int)

  let maps =
    list.map(maps, fn(map) {
      let assert [_name, ..map_items] = string.split(map, "\n")

      map_items
      |> list.map(fn(item) {
        item |> string.split(" ") |> list.map(parse_int) |> make_map
      })
    })
    |> make_maps

  seeds
  |> list.map(process(_, maps.seed_to_soil))
  |> list.map(process(_, maps.soil_to_fertilizer))
  |> list.map(process(_, maps.fertilizer_to_water))
  |> list.map(process(_, maps.water_to_light))
  |> list.map(process(_, maps.light_to_temperature))
  |> list.map(process(_, maps.temperature_to_humidity))
  |> list.map(process(_, maps.humidity_to_location))
  |> list.reduce(int.min)
}

fn process(id: Int, maps: List(Map)) -> Int {
  // io.print(" transforming " <> int.to_string(id))
  case maps {
    [map, ..rem] -> {
      let in_range =
        map.source_start <= id && id <= map.source_start + map.length
      case in_range {
        True -> calculate(id, map.source_start, map.destination_start)
        False -> process(id, rem)
      }
    }
    [] -> id
  }
}

fn calculate(id, source_start, destination_start) {
  let offset = id - source_start
  let res = destination_start + offset

  // io.println(" to " <> int.to_string(res) <> "\n\n")

  res
}

type SeedRange {
  SeedRange(start_id: Int, length: Int)
}

pub fn pt_2(input: String) {
  let assert [seeds, ..maps] = string.split(input, "\n\n")
  let assert [_, seeds] = string.split(seeds, ": ")
  let seeds =
    {
      seeds
      |> string.split(" ")
      |> list.index_fold(#([], 0), fn(acc, curr, i) {
        case i % 2 {
          0 -> #(acc.0, parse_int(curr))
          _ -> #([SeedRange(acc.1, parse_int(curr)), ..acc.0], 0)
        }
      })
    }.0

  let maps =
    list.map(maps, fn(map) {
      let assert [_name, ..map_items] = string.split(map, "\n")

      map_items
      |> list.map(fn(item) {
        item |> string.split(" ") |> list.map(parse_int) |> make_map
      })
    })
    |> make_maps
  seeds
  |> yielder.from_list
  |> yielder.map(fn(s) {
    yielder.from_list([s.start_id, s.start_id + s.length])
  })
  |> yielder.flatten
  |> yielder.map(process(_, maps.seed_to_soil))
  |> yielder.map(process(_, maps.soil_to_fertilizer))
  |> yielder.map(process(_, maps.fertilizer_to_water))
  |> yielder.map(process(_, maps.water_to_light))
  |> yielder.map(process(_, maps.light_to_temperature))
  |> yielder.map(process(_, maps.temperature_to_humidity))
  |> yielder.map(process(_, maps.humidity_to_location))
  |> yielder.reduce(int.min)
}
