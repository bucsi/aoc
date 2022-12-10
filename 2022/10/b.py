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


def draw(sprite_pixels, current_position):
    if current_position in sprite_pixels:
        print("#", end="")
    else:
        print(" ", end="")
    if current_position == 39:
        print()


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
signal_strengths: list[int] = []

for command in program:
    cycle_number += 1
    current_position = (cycle_number-1) % 40
    sprite_pixels = [register_x - 1, register_x, register_x + 1]
    draw(sprite_pixels, current_position)
    match command:
        case Command("noop", _):
            pass
        case Command("addx", value) if value is not None:
            cycle_number += 1
            current_position = (cycle_number-1) % 40
            draw(sprite_pixels, current_position)
            register_x += value
        case _:
            raise ValueError(f"Unknown command: {command}")
