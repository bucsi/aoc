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

copies = [1 for i in range(len(cards))]

for i, card in enumerate(cards):
    points = card.calculate_points_power()
    multiplier = copies[i]
    for x in range(1, points+1):
        copies[i+x] += multiplier

print(sum(copies))