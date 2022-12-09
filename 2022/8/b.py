from __future__ import annotations
from funutils import compose, map_to
import operator


class Tree:

    class ViewingDistance:

        def __init__(self):
            self.top = 0
            self.left = 0
            self.right = 0
            self.bottom = 0

        def score(self) -> int:
            return (self.top * self.left * self.right * self.bottom)

        def __str__(self):
            return f"{self.top=}{self.bottom=}{self.left=}{self.right=}"

    def __init__(self: Tree, height: int) -> None:
        self.height = height
        self.viewing_distance = self.ViewingDistance()

    def __str__(self):
        return (str(self.height))

    def __repr__(self):
        return str(self)


trees: list[list[Tree]] = []
with open("input.txt", "r") as f:
    for row, line in enumerate(f.readlines()):
        tree_row = []
        for col, tree in enumerate(line.strip()):
            tree_row.append(Tree(int(tree)))
        trees.append(tree_row)

for row in trees:
    for i, tree in enumerate(row):
        for right_neighbor in row[i + 1:]:
            tree.viewing_distance.right += 1
            if tree.height <= right_neighbor.height:
                break
        for left_neighbor in reversed(row[:i]):
            tree.viewing_distance.left += 1
            if tree.height <= left_neighbor.height:
                break

for col in zip(*trees):
    for i, tree in enumerate(col):
        for top_neighbor in col[:i]:
            tree.viewing_distance.top += 1
            if tree.height <= top_neighbor.height:
                break
        for bottom_neighbor in reversed(col[i + 1:]):
            tree.viewing_distance.bottom += 1
            if tree.height <= bottom_neighbor.height:
                break


def flatten(list: list[list]) -> list:
    return [item for sublist in list for item in sublist]


solution = compose(
    flatten, map_to(lambda tree: tree.viewing_distance.score()), max
)
print(solution(trees))
