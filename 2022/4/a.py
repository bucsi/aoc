from __future__ import annotations
from funutils import compose, map_to, filter_with


class SectionAssignment:

    def __init__(self, section: str) -> None:
        self.start, self.end = [int(x) for x in section.split("-")]

    def __contains__(self, other: SectionAssignment) -> bool:
        return self.start <= other.start and other.end <= self.end

    def __str__(self):
        return f"SectionAssignment<{self.start}-{self.end}>"


def splitter(line: str) -> list[str]:
    return line.split(",")


def create_assignments(pair: list[str]) -> list[SectionAssignment]:
    return [SectionAssignment(elem) for elem in pair]


def is_overlapping(pair: list[SectionAssignment]) -> bool:
    first, second = pair
    if res1 := first in second:
        print(f"{first} is inside {second}.")
    if res2 := second in first:
        print(f"{first} contains {second}.")
    return res1 or res2


with open('input.txt', 'r') as infile:
    print(SectionAssignment("1-10") in SectionAssignment("5-6"))
    print(SectionAssignment("1-10") in SectionAssignment("0-20"))
    lines = [line.strip() for line in infile.readlines()]
    solution = compose(
        map_to(splitter),
        map_to(create_assignments),
        filter_with(is_overlapping),
    )
    print(f"{len(list(solution(lines)))} assignments fully overlap.")
