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

part1 = puzzleInput 
    |> Str.split "\n\n"
    |> List.map (\item -> Str.split item "\n")
    |> List.map (\sublist -> 
        List.keepOks sublist Str.toI32
        |> List.sum
    )
    |> List.sortDesc
    |> List.first
    |> Result.map \highest -> "highest \(Num.toStr highest)"
    |> Result.withDefault "There was an error"

part2 =
    part1
    |> Str.toScalars
    |> List.reverse
    |> List.walk
        ""
        (\state, element -> Str.appendScalar state element
            |> Result.withDefault "?")
