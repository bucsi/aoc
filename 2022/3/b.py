from funutils import compose, map_to

LETTERS = '#abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'


def common_item(compartments: list[str]) -> str:
    first, second, third = map(set, compartments)
    return first.intersection(second).intersection(third).pop()


def get_priority(item: str) -> int:
    return LETTERS.index(item)


with open('input.txt', 'r') as infile:

    lines = [line.strip() for line in infile.readlines()]
    groups = [lines[i:i + 3] for i in range(0, len(lines), 3)]
    solution = compose(map_to(common_item), map_to(get_priority), sum)

    print(solution(groups))
