from collections import namedtuple
from functional_utilities import chain, map_to

coords = namedtuple("coords", ['row', 'col'])

with open("input.txt", "r") as inf:
    data = [list(line.strip()) for line in inf.readlines()]

MAX_COL = len(data[0])

value_collector = []

def is_gear(char):
    return char == "*" 

def neighbor_coords(i,j):
    return [
        coords(i-1, j),
        coords(i-1, j+1),
        coords(i, j+1),
        coords(i+1, j+1),
        coords(i+1, j),
        coords(i+1, j-1),
        coords(i, j-1),
        coords(i-1, j-1),
    ]

def get_number(c: coords):
    global data
    i, j = c.row, c.col
    value = data[i][j]
    if value == "." or not value.isnumeric():
        return None
    else:
        data[i][j] = "."
        result = [value]
        j -= 1 #start looking left side
        while (j >= 0 and data[i][j].isnumeric()):
            result.insert(0, data[i][j])
            data[i][j] = "."
            j -= 1
        j = c.col + 1 #start looking right side
        while (j < MAX_COL and data[i][j].isnumeric()):
            result.append(data[i][j])
            data[i][j] = "."
            j += 1
        value_collector.append(result)
        return int("".join(result))

gear_ratios = []

for i, line in enumerate(data):
    for j, char in enumerate(line):
        if is_gear(char):
            adjacent_fields = []
            for c in neighbor_coords(i,j):
                adjacent_fields.append(get_number(c))
            adjacent_numbers = [field for field in adjacent_fields if field != None]
            if(len(adjacent_numbers) == 2):
                gear_ratios.append(adjacent_numbers[0] * adjacent_numbers[1])

print(sum(gear_ratios))