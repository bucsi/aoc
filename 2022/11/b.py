from tqdm import tqdm
import os
from operator import mul
from functools import reduce


def squared(item: int):
    return item**2


def make_operation(operation: str) -> tuple[str, int | None]:
    left, operand, right = operation.split(" ")
    if operand == "+":
        return ("add", int(right))
    if left == right:
        return ("square", None)
    return ("mul", int(right))


class Monkey:

    def __init__(
        self,
        name: str,
        items: list[int],
        operation: str,
        test: int,
        if_true: int,
        if_false: int
    ):
        self.name = name
        self.items: list[int] = items
        self.operation = make_operation(operation)
        self.test_value = test
        self.if_true = if_true
        self.if_false = if_false
        self.counted_items = 0

    def handle_items(self):
        self.counted_items += len(self.items)
        for item in self.items:
            self.process(item)

        self.items = []

    def process(self, item):
        global monkeys, least_common_multiple
        item = self.perform_operation(item) % least_common_multiple
        if self.test(item):
            monkeys[self.if_true].items.append(item)
        else:
            monkeys[self.if_false].items.append(item)

    def perform_operation(self, item) -> int:
        if self.operation[0] == "add":
            return item + self.operation[1]
        if self.operation[0] == "mul":
            return item * self.operation[1]
        return item**2

    def test(self, item) -> bool:
        return item % self.test_value == 0

    def __str__(self) -> str:
        return f"""
{self.name}
  Starting items: {self.items}
  Operation: new = {self.operation}
  Test: {self.test_value} ({self.test})
    If true: throw to monkey {self.if_true}
    If false: throw to monkey {self.if_false}
"""

    def __repr__(self) -> str:
        return str(self)


monkeys: list[Monkey] = []

with open("input.txt", "r") as f:
    monkey_descriptions = [
        monkey.strip().split("\n") for monkey in f.read().split("\n\n")
    ]

    for monkey in monkey_descriptions:
        name, items, operation, test, if_true, if_false = monkey
        items = [int(item) for item in items.split(": ")[1].split(", ")]
        operation = operation.split("= ")[1].replace("old", "item")
        test = int(test.split("by ")[1])
        if_true = int(if_true.split("monkey ")[1])
        if_false = int(if_false.split("monkey ")[1])
        monkeys.append(Monkey(name, items, operation, test, if_true, if_false))

divisors = map(lambda monkey: monkey.test_value, monkeys)
least_common_multiple = reduce(lambda s, x: s * x, divisors, 1)
print(least_common_multiple)

for round in range(10_000):
    os.system("clear")
    tqdm.write(f"{round/10_000*100:.2f}%")
    for monkey in monkeys:
        monkey.handle_items()

first, second, *rest = sorted(map(lambda monkey: monkey.counted_items, monkeys), reverse=True)
print(first, second, first * second)