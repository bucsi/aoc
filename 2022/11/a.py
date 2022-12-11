from math import floor


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
        self.operation = operation
        self.test = eval(f"lambda item: item % {test} == 0")
        self.test_value = test
        self.if_true = if_true
        self.if_false = if_false
        self.counted_items = 0

    def handle_items(self):
        global monkeys
        self.counted_items += len(self.items)
        for item in self.items:
            print("Monkey is handling:", item)
            print("Worry level set to:", eval(self.operation))
            item = floor(eval(self.operation) / 3)
            print("Worry level divided by 3 to:", item)
            print(
                "Worry level is divisible by",
                self.test_value,
                "?",
                self.test(item)
            )
            if self.test(item):
                print("Item thrown to monkey", self.if_true)
                monkeys[self.if_true].items.append(item)
            else:
                print("Item thrown to monkey", self.if_false)
                monkeys[self.if_false].items.append(item)

        self.items = []

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
        operation = operation.split("=")[1].replace("old", "item")
        test = int(test.split("by ")[1])
        if_true = int(if_true.split("monkey ")[1])
        if_false = int(if_false.split("monkey ")[1])
        monkeys.append(Monkey(name, items, operation, test, if_true, if_false))

for round in range(20):
    for monkey in monkeys:
        print(monkey.name)
        monkey.handle_items()

first, second, *rest = sorted(map(lambda monkey: monkey.counted_items, monkeys), reverse=True)
print(first, second, first * second)
