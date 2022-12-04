from __future__ import annotations
from funutils import compose, map_to, filter_with


class SectionAssignment:

    def __init__(self, section: str) -> None:
        self.start, self.end = [int(x) for x in section.split("-")]

    def __contains__(self, other: SectionAssignment) -> bool:
        self_sections, other_sections = self._get_sections(), other._get_sections()
        return (
            self_sections.issubset(other_sections) or
            other_sections.issubset(self_sections)
        )

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


def is_full_overlap(pair: list[SectionAssignment]) -> bool:
    first, second = pair
    return first in second


def is_not_empty_set(set: set) -> bool:
    return len(set) != 0


solution1 = compose(
    map_to(splitter),
    map_to(create_assignments),
    filter_with(is_full_overlap)
)
solution2 = compose(
    map_to(splitter),
    map_to(create_assignments),
    map_to(get_overlaps),
    filter_with(is_not_empty_set),
)

with open('sample.txt', 'r') as infile:
    lines = [line.strip() for line in infile.readlines()]
    print("✅" if len(list(solution1(lines))) == 2 else "❌", "Task 1")
    print("✅" if len(list(solution2(lines))) == 4 else "❌", "Task 2")

with open('input.txt', 'r') as infile:
    lines = [line.strip() for line in infile.readlines()]
    print(f"{len(list(solution1(lines)))} assignments fully overlap.")
    print(f"{len(list(solution2(lines)))} assignments partially overlap.")
