from geometry import Line
from data_structures import Multiset

with open("input", "r") as f:
    data = [Line(x) for x in f.readlines()]


m = Multiset()
for line in data:
    if(line.is_vertical() or line.is_horizontal()):
        for p in line.gen_points():
            m.add(p)
print(f"[Part 1] Number of intersecting vents when considering vertical or horizontals only: {m.get_count_more_than(2)}")
for line in data:
    if(not line.is_vertical() and not line.is_horizontal()):
        for p in line.gen_points():
            m.add(p)
print(f"[Part 2] Number of intersecting vents when considering diagonals as well: {m.get_count_more_than(2)}")      

