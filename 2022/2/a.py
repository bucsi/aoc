RPS_POINTS = {"R": 1, "P": 2, "S": 3}


def score(player):
    return RPS_POINTS[player]


def rps(code):
    if code in ["A", "X"]:
        return "R"
    if code in ["B", "Y"]:
        return "P"
    if code in ["C", "Z"]:
        return "S"


def play(opponent, player):
    if opponent == 'R':
        if player == 'R':
            return 3
        if player == 'P':
            return 6
        if player == 'S':
            return 0
    if opponent == 'P':
        if player == 'R':
            return 0
        if player == 'P':
            return 3
        if player == 'S':
            return 6
    if opponent == 'S':
        if player == 'R':
            return 6
        if player == 'P':
            return 0
        if player == 'S':
            return 3


def convert(line):
    opponent, player = map(rps, line.split(" "))
    return play(opponent, player) + score(player)


with open("input.txt", 'r') as infile:
    print(sum(map(convert, [line.strip() for line in infile.readlines()])))
