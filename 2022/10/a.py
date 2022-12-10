from funutils import compose, map_to
from typing import NamedTuple

Command = NamedTuple(
    "Instruction", [("instruction", str), ("value", int | None)]
)


def build_command(line: list[str]) -> Command:
    if len(line) == 1:
        return Command(line[0], None)

    instruction, value = line
    return Command(instruction, int(value))

def check_signal_strenght(register_x, cycle_number):
    if cycle_number in range(20,270,40):
        print(f"Cycle {cycle_number}: {register_x=}, signal strength: {(signal_strength := register_x * cycle_number)}")
        signal_strengths.append(signal_strength)


with open("input.txt", "r") as f:
    lines = f.readlines()

    parse_input = compose(
        map_to(lambda line: line.strip().split(" ")),
        map_to(build_command),
        list
    )

    program = parse_input(lines)

register_x = 1
cycle_number = 0
signal_strengths:list[int] = []

for command in program:
    cycle_number += 1
    check_signal_strenght(register_x, cycle_number)
    match command:
        case Command("noop", _):
            pass
        case Command("addx", value) if value is not None:
            cycle_number += 1
            check_signal_strenght(register_x, cycle_number)
            register_x += value
        case _:
            raise ValueError(f"Unknown command: {command}")
print(sum(signal_strengths))