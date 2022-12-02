RPS_POINTS = {"R": 1, "P": 2, "S": 3}


def rps(code):
    if code in ["A", "X"]:
        return "R"
    if code in ["B", "Y"]:
        return "P"
    if code in ["C", "Z"]:
        return "S"


def play(opponent, player):
    if opponent == 'R':
        if player == 'X':
            return 0 + RPS_POINTS['S']
        if player == 'Y':
            return 3 + RPS_POINTS['R']
        if player == 'Z':
            return 6 + RPS_POINTS['P']
    if opponent == 'P':
        if player == 'X':
            return 0 + RPS_POINTS['R']
        if player == 'Y':
            return 3 + RPS_POINTS['P']
        if player == 'Z':
            return 6 + RPS_POINTS['S']
    if opponent == 'S':
        if player == 'X':
            return 0 + RPS_POINTS['P']
        if player == 'Y':
            return 3 + RPS_POINTS['S']
        if player == 'Z':
            return 6 + RPS_POINTS['R']


def convert(line):
    opponent, player = line.split(" ")
    print(opponent, player)
    return play(rps(opponent), player)


with open("input.txt", 'r') as infile:
    print(sum(map(convert, [line.strip() for line in infile.readlines()])))
