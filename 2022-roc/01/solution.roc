app "day0"
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

process : Str -> List I32
process = \string -> string
    |> Str.split "\n\n"
    |> List.map (\item -> Str.split item "\n")
    |> List.map (\sublist -> 
        List.keepOks sublist Str.toI32
        |> List.sum
    )

part1 = puzzleInput 
    |> process
    |> List.sortDesc
    |> List.first
    |> Result.map \highest -> "highest \(Num.toStr highest)"
    |> Result.withDefault "There was an error"

part2 = puzzleInput
    |> process
    |> List.takeFirst 3
    |> List.sum
    |> Num.toStrcd 
