from dataclasses import dataclass
from typing import Literal, Self
from functional_utilities import chain, filter_with, map_to


@dataclass
class RevelationRecord:
    red: int
    green: int
    blue: int

    def __init__(self):
        self.red = 0
        self.green = 0
        self.blue = 0

    def add(self, color: Literal["red", "green", "blue"], count: int) -> Self:
        match (color):
            case "red":
                self.red += count
            case "green":
                self.green += count
            case "blue":
                self.blue += count
        return self

    def is_possible(self) -> bool:
        return (
            self.red <= RED_TOTAL
            and self.green <= GREEN_TOTAL
            and self.blue <= BLUE_TOTAL
        )


@dataclass
class GameRecord:
    id: int
    revelations: list[RevelationRecord]

    def __init__(self, id: int):
        self.id = id
        self.revelations = []

    def add_revelations(self, revelations: list[RevelationRecord]):
        self.revelations = revelations

    def add(self, revelation: RevelationRecord):
        self.revelations.append(revelation)

    def is_possible(self):
        # return all([revelation.is_possible() for revelation in self.revelations])
        max_counts = {
            'red': max(revelation.red for revelation in self.revelations),
            'green': max(revelation.green for revelation in self.revelations),
            'blue': max(revelation.blue for revelation in self.revelations),
        }

        possible = all(count <= total_count for count, total_count in zip(max_counts.values(), (RED_TOTAL, GREEN_TOTAL, BLUE_TOTAL)))

        if not possible:
            print(f"Game {self.id} is not possible. Max counts: {max_counts}, Total counts: ({RED_TOTAL}, {GREEN_TOTAL}, {BLUE_TOTAL})")

        return possible
    
    def total(self):
        return f"{self.id=} red = {max([revelation.red for revelation in self.revelations])}, green = {max([revelation.green for revelation in self.revelations])}, blue = {max([revelation.blue for revelation in self.revelations])}"


# only 12 red cubes, 13 green cubes, and 14 blue cubes
RED_TOTAL = 12
GREEN_TOTAL = 13
BLUE_TOTAL = 14
FILENAME = "./magic.txt"

with open(FILENAME, "r") as inf:
    data = [line for line in inf.readlines()]


games: list[GameRecord] = []
for line in data:
    game_str, revelations_str = line.split(":")
    game_id = game_str.split(" ")[1]
    game = GameRecord(int(game_id))

    for revelation_str in revelations_str.split(";"):
        revelation = RevelationRecord()
        for grabbed in revelation_str.split(","):
            color: Literal["red", "green", "blue"]
            _, count, color = grabbed.split(" ")  # type: ignore
            revelation.add(color, int(count))
        game.add(revelation)
    games.append(game)


part1 = chain(
    filter_with(lambda g: g.is_possible()),
    map_to(lambda g: g.id),
    sum
    # map_to(lambda g: g.total()),
    # list
)
print(part1(games))

# for i in part1(games):
#     print(i)
