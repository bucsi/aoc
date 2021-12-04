from bingo import Board


with open("input", "r") as f:
    data = [x.strip() for x in f.readlines()]
    numbers = data[0].split(",")
    boards = []
    for i in range(1, len(data), 6):
        boards.append(Board())
        for j in range(1, 6):
            # split string at single or double spaces
            # and remove empty strings
            boards[-1].fill_next_row([x for x in data[i + j].split(" ") if x])


def active_boards():
    return sum([1 for b in boards if b.active])


def solve():
    part_one = True
    for n in numbers:
        for b in boards:
            if b.active and b.mark(n) and b.check_win():
                if part_one:
                    print(f"The following board won:{b}")
                    print(f"The last drawn number was {n}")
                    print(f"Sum of unmarked numbers on board: {(sum := b.sum())}")
                    print(f"The answer to part one: {sum}")
                    part_one = False
                if active_boards() > 1:
                    b.active = False
                    print(
                        f"A board was eliminated. Remaining boards: {active_boards()}"
                    )
                else:
                    print(f"The following was the last board:{b}")
                    print(f"The last drawn number was {n}")
                    print(f"Sum of unmarked numbers on board: {(sum := b.sum())}")
                    print(f"The answer to part two: {n*sum}")
                    return


solve()
