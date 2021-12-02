from collections import namedtuple
Command = namedtuple('Command', ["direction", "amount"])

# take a list of lists and convert it to list of namedtuples
def convert(list:list[list[str,str]]) -> list[Command]:
    return [Command(list[i][0], int(list[i][1])) for i in range(len(list))]

#open the file called input and read in data
with open("input", 'r') as f:
    data = convert([x.strip().split(" ") for x in f.readlines()])

depth = 0
horizontal_pos = 0
vertical_pos = 0
aim = 0

for command in data:
    match command.direction:
        case "forward":
            horizontal_pos += command.amount
            depth += aim * command.amount
        case "down":
            aim += command.amount
            vertical_pos += command.amount
        case "up":
            aim -= command.amount
            vertical_pos -= command.amount

print(f"--- Part One ---\nThe depth is {vertical_pos} and the horizontal position is {horizontal_pos}\nThe first puzzle solution is {vertical_pos * horizontal_pos}")
print(f"--- Part Two ---\nThe depth is {depth} and the horizontal position is {horizontal_pos}\nThe second puzzle solution is {depth * horizontal_pos}")
