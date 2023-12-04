from dataclasses import dataclass
from functional_utilities import chain, map_to, filter_with

@dataclass
class Scratchcard:
    name: str
    winning_numbers: list[str]
    numbers_i_have: list[str]

    def __init__(self, string: str):
        self.name, rest = string.split(":")
        winning, own = rest.split(" | ")
        self.winning_numbers = winning.replace("  ", " ").split(" ")[1:] # leave first, empty element behind
        self.numbers_i_have = own.replace("  ", " ").split(" ")
    
    def calculate_points_power(self):
        return sum([1 for i in self.numbers_i_have if i in self.winning_numbers])
    
with open("input.txt", "r") as inf:
    cards = [Scratchcard(line.strip()) for line in inf.readlines()]

part1 = chain(
    map_to(lambda c: c.calculate_points_power()),
    filter_with(lambda n: n>0),
    map_to(lambda n: 2**(n-1)),
    sum
)

print(f"{part1(cards)=}")