from __future__ import annotations
from termcolor import colored


class Tree:

    def __init__(self: Tree, height: int, visible: bool = False) -> Tree:
        self.height = height
        self.visible = visible

    def __str__(self):
        return (
            colored(self.height, "green") if self.visible else str(self.height)
        )


trees = []
with open("input.txt", "r") as f:
    for row, line in enumerate(f.readlines()):
        tree_row = []
        for col, tree in enumerate(line.strip()):
            tree_row.append(Tree(int(tree), row, col))
        trees.append(tree_row)

for row in trees:
    left_highest_so_far = -1
    right_highest_so_far = -1
    for tree in row:
        if tree.height > left_highest_so_far:
            tree.visible = True
            left_highest_so_far = tree.height
    for tree in reversed(row):
        if tree.height > right_highest_so_far:
            tree.visible = True
            right_highest_so_far = tree.height

for col in zip(*trees):
    top_highest_so_far = -1
    bottom_highest_so_far = -1
    for tree in col:
        if tree.height > top_highest_so_far:
            tree.visible = True
            top_highest_so_far = tree.height
    for tree in reversed(col):
        if tree.height > bottom_highest_so_far:
            tree.visible = True
            bottom_highest_so_far = tree.height

for i, row in enumerate(trees):
    for j, tree in enumerate(row):
        print(tree, end="")
    print()

print(len([tree for row in trees for tree in row if tree.visible]))
