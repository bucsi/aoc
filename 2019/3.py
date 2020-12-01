import sys
sys.setrecursionlimit(1500) #deepest we go is ~1000,which hits the conservative python limit

def get_input(filename):
    with open(filename, "r") as f:
        return f.read().split("\n")

def distanceFromZero (some_tuple):
    return abs(some_tuple[0]) + abs(some_tuple[1])

def parseDirection(direction, step, biglist):
    if step > 0:
        x = biglist[-1][0]
        y = biglist[-1][1]
        if direction == "R":
            x += 1
        elif direction == "L":
            x -= 1
        elif direction == "U":
            y += 1
        elif direction == "D":
            y -= 1
        biglist.append((x,y))
        parseDirection(direction, step-1, biglist)

l1 = [(0,0)]
l2 = [(0,0)]

p1, p2 = get_input("3.txt")

for elem in p1.split(","):
    d = elem[0]
    s = int(elem[1:])
    parseDirection(d,s,l1)

for elem in p2.split(","):
    d = elem[0]
    s = int(elem[1:])
    parseDirection(d,s,l2)

points = set(l1).intersection(l2)
points.remove((0,0))
print("smallest distance: ",min([distanceFromZero(x) for x in points]))
print("smallest common distance:",min([l1.index(p) + l2.index(p) for p in points]))