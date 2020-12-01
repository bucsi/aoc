from collections import Counter

with open("be3.txt", "r") as bef:
    p = [x.strip("\n") for x in bef.readlines()]

correct = len(p)

for sor in p:
    l = []
    for v in sor.split(" "):
        l.append("".join(sorted(v)))
    for w in Counter(l).values():
        print(Counter(l).values())
        if w != 1:
            print
            correct -= 1
            break
print(correct)
