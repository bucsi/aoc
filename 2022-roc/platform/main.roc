platform "aoc"
    requires {} { solution : [Part1, Part2] -> Str }
    exposes []
    packages {}
    imports []
    provides [solutionForHost]

solutionForHost : [Part1, Part2] -> Str
solutionForHost = \part ->
    when part is
        Part1 -> solution Part1
        Part2 -> solution Part2
