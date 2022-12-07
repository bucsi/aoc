from collections import namedtuple
from funutils import compose, filter_with, map_to

Directory = namedtuple("Directory", ["parent", "fullpath", "size"])


def add_size(dir:Directory, size: int) -> None:
    filesystem[dir.fullpath] = dir._replace(size=dir.size+size)
    if dir.parent != "":
        add_size(filesystem[dir.parent], size)


get_total_file_sizes = compose(
    filter_with(lambda elem: elem.split(" ")[0] != "dir"),
    map_to(lambda elem: int(elem.split(" ")[0])),
    sum
)


def make_directory(parent: str, fullpath: str) -> Directory:
    return Directory(
        parent =  parent,
        fullpath = fullpath,
        size = 0
    )


filesystem: dict[str, Directory] = {
    "/": make_directory("", "/")
}

with open('input.txt', 'r') as f:
    prepare_input = compose(
        map_to(lambda command: command.strip().split("\n")),
        map_to(lambda command: command[0].split(" ") + command[1:]),
        list
    )
    input = prepare_input(f.read().split("$"))
    del input[0:2]

current_path = "/"

for command in input:
    match command:
        case ["cd", dirname]:
            new_path = current_path + ("" if len(current_path)<2 else "/") + dirname
            filesystem[new_path] = make_directory(current_path, new_path)
            current_path = new_path

        case ["cd", ".."]:
            current_path = current_path[:current_path.rfind("/")]
            if current_path == "":
                current_path = "/"

        case ["ls", *output]:
            add_size(filesystem[current_path], get_total_file_sizes(output))

solution1 = compose(
    filter_with(lambda dir: dir.size <= 100_000),
    map_to(lambda dir: dir.size),
    sum
)

print(f"{solution1(filesystem.values())} <-- Part 1 (sum of total sizes of directories with a total size of at most 100_000)")

TOTAL_SIZE = 70_000_000
NEEDED_SIZE = 30_000_000
USED_SIZE = filesystem["/"].size
UNUSED_SIZE = TOTAL_SIZE - USED_SIZE
TARGET_SIZE = NEEDED_SIZE - UNUSED_SIZE

solution2 = compose(
    map_to(lambda dir: dir.size),
    filter_with(lambda size: size >= TARGET_SIZE),
    sorted,
    min
)

print(f"{solution2(filesystem.values())} <-- Part 2 (total size of the directory that, if deleted, would free up enough space)")