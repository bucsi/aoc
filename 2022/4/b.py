from __future__ import annotations
from funutils import compose, map_to, filter_with


class SectionAssignment:

    def __init__(self, section: str) -> None:
        self.start, self.end = [int(x) for x in section.split("-")]

    def __contains__(self, other: SectionAssignment) -> bool:
        return self.start <= other.start and other.end <= self.end

    def get_overlap(self, other: SectionAssignment) -> set:
        return self._get_sections().intersection(other._get_sections())

    def _get_sections(self) -> set[int]:
        return set(range(self.start, self.end + 1))

    def __str__(self):
        return f"SectionAssignment<{self.start}-{self.end}>"


def splitter(line: str) -> list[str]:
    return line.split(",")


def create_assignments(pair: list[str]) -> list[SectionAssignment]:
    return [SectionAssignment(elem) for elem in pair]


def get_overlaps(pair: list[SectionAssignment]) -> set:
    first, second = pair
    return first.get_overlap(second)


def is_not_empty_set(set: set) -> bool:
    return len(set) != 0


with open('input.txt', 'r') as infile:
    print(SectionAssignment("1-10") in SectionAssignment("5-6"))
    print(SectionAssignment("1-10") in SectionAssignment("0-20"))
    lines = [line.strip() for line in infile.readlines()]
    solution = compose(
        map_to(splitter),
        map_to(create_assignments),
        map_to(get_overlaps),
        filter_with(is_not_empty_set),
    )
    print(f"{len(list(solution(lines)))} assignments partially overlap.")
