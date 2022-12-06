from __future__ import annotations
from funutils import compose, map_to, apply, filter_with


class Stack:

    def __init__(self, crates: list[str]) -> Stack:
        self._crates = crates

    def remove(self, count: int) -> list[str]:
        self._crates, removed = self._crates[count:], self._crates[:count]
        return list(reversed(removed))

    def add(self, crates: list[str]) -> None:
        self._crates = crates + self._crates

    def top(self):
        return self._crates[0]


def strip_crates(line: str) -> str:
    return line.replace("]",
                        "").replace("[",
                                    "").replace("] ",
                                                "").replace(" [",
                                                            "").replace(
                                                                "    ",
                                                                "-"
                                                            ).replace(" ",
                                                                      "")


# move 1 from 2 to 1
def prepare_operations(line: str) -> str:
    return [
        int(x) for x in line.replace("move ",
                                     "").replace("from ",
                                                 "").replace("to ",
                                                             "").split(" ")
    ]


def transpose_crates(crates: map):
    crates = list(crates)
    print(crates)
    print(len(crates))
    print(len(crates[0]))
    return [
        [crates[j][i]
         for j in range(len(crates))]
        for i in range(len(crates[0]))
    ]


def construct_stack(crates: list[str]) -> Stack:
    return Stack(list(filter(lambda s: s != '-', crates)))


with open('sample.txt', 'r') as infile:
    lines = [line.strip("\n") for line in infile.readlines()]

separator_line = lines.index('')
stack_strings, procedure = lines[:separator_line - 1], lines[separator_line + 1:]

prepare_stacks = compose(
    map_to(strip_crates),
    apply(transpose_crates),
    map_to(construct_stack)
)

# move 1 from 2 to 1
operations = map(prepare_operations, procedure)
stacks = [None] + list(prepare_stacks(stack_strings))

for operation in operations:
    count, from_stack, to_stack = operation
    stacks[to_stack].add(stacks[from_stack].remove(count))

print(''.join([stack.top() if stack else "" for stack in stacks]))