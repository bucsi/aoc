from collections import Counter

with open("be3.txt", "r") as bef:
    p = [x.strip("\n") for x in bef.readlines()]
correct = len(p)

for sor in p:
    for v in Counter(sor.split()).values():
        if v != 1:
            print
            correct -= 1
            break
print(correct)
