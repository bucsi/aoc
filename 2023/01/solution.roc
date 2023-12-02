app "day1"
    packages {
        pf: "../platform/main.roc",
    }
    imports [
        "sample.txt" as sample : Str,
        "input.txt" as input : Str
    ]
    provides [solution] to pf

solution = \part ->
    when part is
        Part1 -> part1
        Part2 -> part2

puzzleInput = sample

parse : Str -> List List I32
parse = \string -> string
    |> Str.split "\n"
    |> List.map (\sublist -> sublist
        |> Str.graphemes
        |> List.keepOks Str.toI32
    )

takeFirstAndLast : List I32 -> List I32
takeFirstAndLast = \list ->
    List.withCapacity 2
    |> List.set 0 (
        List.first list
        |> Result.withDefault 0
    )
    |> List.set 1 (
        List.last list
        |> Result.withDefault 0
    )


part1 = puzzleInput 
    |> parse
    |> List.map takeFirstAndLast
    |> List.map Num.toStr
    |> List.map (\list -> Str.joinWith list "")
    |> List.keepOks Str.toI32
    |> List.sum
    |> Num.toStr

part2 = puzzleInput
#     |> process
#     |> List.takeFirst 3
#     |> List.sum
#     |> Num.toStr
