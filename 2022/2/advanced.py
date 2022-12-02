from typing import Literal

Shape = Literal['R', 'P', 'S']

SHAPES = {
    'R': {
        'loses_against': 'P',
        'wins_against': 'S',
        'points': 1
    },
    'P': {
        'loses_against': 'S',
        'wins_against': 'R',
        'points': 2
    },
    'S': {
        'loses_against': 'R',
        'wins_against': 'P',
        'points': 3
    }
}

class SCORE:
    WIN = 6
    LOSE = 0
    DRAW = 3

class ACTION:
    LOSE = 'X'
    DRAW = 'Y'
    WIN = 'Z'

def wins_against(shape: Shape) -> Shape:
    return SHAPES[shape]['wins_against']

def loses_against(shape: Shape) -> Shape:
    return SHAPES[shape]['loses_against']

def get_win_against(shape: Shape) -> Shape:
    return loses_against(shape)

def get_lose_against(shape: Shape) -> Shape:
    return wins_against(shape)

def get_points(shape: Shape) -> int:
    return SHAPES[shape]['points']

def parse_code(code: Shape) -> Shape:
    match code:
        case "A" | "X":
            return "R"
        case "B" | "Y":
            return "P"
        case "C" | "Z":
            return "S"

def calculate_score_1(codes: list[str]) -> int:
    opponent, player = map(parse_code, codes)
    if player == wins_against(opponent):
        return SCORE.WIN + get_points(player)
    elif player == loses_against(opponent):
        return SCORE.LOSE + get_points(player)
    else:
        return SCORE.DRAW + get_points(player)

def calculate_score_2(codes: list[str]) -> int:
    opponent, action = parse_code(codes[0]), codes[1]
    match action:
        case ACTION.WIN:
            return SCORE.WIN + get_points(get_win_against(opponent))
        case ACTION.LOSE:
            return SCORE.LOSE + get_points(get_lose_against(opponent))
        case ACTION.DRAW:
            return SCORE.DRAW + get_points(opponent)



with open("sample.txt", 'r') as infile:
    lines = [line.strip().split(' ') for line in infile.readlines()]
    print('✅' if sum(map(calculate_score_1, lines)) == 15 else '❌', "First part")
    print('✅' if sum(map(calculate_score_2, lines)) == 12 else '❌', "Second part")

with open("input.txt", 'r') as infile:
    lines = [line.strip().split(' ') for line in infile.readlines()]
    print('First part:', sum(map(calculate_score_1, lines)))
    print('Second part:', sum(map(calculate_score_2, lines)))