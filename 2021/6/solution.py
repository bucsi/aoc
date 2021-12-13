from fish import Fishies


with open("input", "r") as f:
    f = Fishies([int(x) for x in f.read().split(",")])

for i in range(256):
    f.inc_day()
    if(i==79):
        print(f"Day 80: {len(f)}")
print(f"Day 256: {len(f)}")