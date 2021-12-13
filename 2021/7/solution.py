#from tqdm import tqdm
from sys import maxsize as MAX
from math import ceil,floor
from statistics import median,mean

with open("input", "r") as f:
    crabs = [int(x) for x in f.read().split(",")]

def fuel_consumption(n):
    acc = 0
    for i in range(1, n):
        acc += i
    return acc+n


median_pos = median(crabs)
mean_pos = mean(crabs)
floored = sum([fuel_consumption(abs(x - floor(mean_pos))) for x in crabs])
ceiled = sum([fuel_consumption(abs(x - ceil(mean_pos))) for x in crabs])

print(f"Median (for part 1): {median_pos}")
print(f"Mean (for part 2, rounded): {mean_pos}")
print(f"Solution for floor(mean) ({floor(mean_pos)}): {floored} fuel consumed")
print(f"Solution for ceil(mean) ({ceil(mean_pos)}): {ceiled} fuel consumed")

print()
print(f"Part 1 solution: {sum([abs(x - median_pos) for x in crabs])} fuel consumed")
print(f"Part 2 solution: {min(floored, ceiled)} fuel consumed")
exit()

## code to find part 2 solution by brute force
pos = -1
min_fuel = MAX
for i in tqdm(range(1, max(crabs))):
    fuel = sum([fuel_consumption(abs(x - i)) for x in crabs])
    if fuel < min_fuel:
        min_fuel = fuel
        pos = i
print(f"Part 2 solution from imperative approach: {min_fuel} fuel consumed to get to position {pos}")
