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


with open("sample.txt", "r") as f:
    steps = [step_builder(*line.strip().split(" ")) for line in f.readlines()]

print(steps)

head = Position()
tail = Position()
visited: set[tuple[int, int]] = set()
visited.add(tail.get_coords())

for step in steps:
    for i in range(step.amount):
        head.step(step.direction)
        direction, distance = tail.get_direction_towards(head)
        if distance > 1:
            tail.step(direction)
            visited.add(tail.get_coords())

print(len(list(visited)))
