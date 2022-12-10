from __future__ import annotations
from collections import namedtuple
import math

Step = namedtuple("Step", ["direction", "amount"])


def step_builder(direction: str, amount: str) -> Step:
    return Step(direction, int(amount))


class Position:

    def __init__(self, x=5000, y=5000) -> None:
        self.x = x
        self.y = y

    def step(self, direction: str) -> None:
        if "U" in direction:
            self.y += 1
        if "D" in direction:
            self.y -= 1
        if "L" in direction:
            self.x -= 1
        if "R" in direction:
            self.x += 1

    def get_direction_towards(self, other: Position) -> tuple[str, int]:
        direction = ""
        if self.x < other.x:
            direction += "R"
        if other.x < self.x:
            direction += "L"
        if self.y < other.y:
            direction += "U"
        if other.y < self.y:
            direction += "D"

        return (
            direction, round(math.dist(self.get_coords(), other.get_coords()))
        )

    def get_coords(self) -> tuple[int, int]:
        return (self.x, self.y)


with open("input.txt", "r") as f:
    steps = [step_builder(*line.strip().split(" ")) for line in f.readlines()]

head = Position()
rope = [
    Position(),  #1
    Position(),  #2
    Position(),  #3
    Position(),  #4
    Position(),  #5
    Position(),  #6
    Position(),  #7
    Position(),  #8
    Position(),  #9
]
visited: set[tuple[int, int]] = set()
visited.add(Position().get_coords())

for step in steps:
    for i in range(step.amount):
        head.step(step.direction)
        previous_knot = head
        for id, knot in enumerate(rope):
            direction, distance = knot.get_direction_towards(previous_knot)
            if distance > 1:
                knot.step(direction)
                if id == 8:
                    visited.add(knot.get_coords())
            previous_knot = knot

print(len(list(visited)))
