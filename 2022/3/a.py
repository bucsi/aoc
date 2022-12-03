from funutils import compose, map_to

LETTERS = '#abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'


def splitter(line: str) -> list[set[str], set[str]]:
    compartment_size = int(len(line) / 2)
    return [set(line[:compartment_size]), set(line[compartment_size:])]


def find_common(compartments: list[set[str], set[str]]) -> str:
    first, second = compartments
    return first.intersection(second).pop()


def get_priority(item: str) -> int:
    return LETTERS.index(item)


with open('input.txt', 'r') as infile:
    lines = [line.strip() for line in infile.readlines()]
    solution = compose(
        map_to(splitter),
        map_to(find_common),
        map_to(get_priority),
        sum
    )
    print(solution(lines))
