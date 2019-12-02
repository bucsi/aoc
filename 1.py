"""onle-liner for part 1
with open("1.txt", "r") as infile:
    print(sum([int(int(x)/3)-2 for x in infile.readlines()]))
"""


def calculate(mass):
    if mass < 6:
        return 0
    return int(mass/3-2) + calculate(int(mass/3-2))

with open("1.txt", "r") as infile:
    print(sum([calculate(int(x)) for x in infile.readlines()]))


"""
uzemanyaglist x = sum (map (uzemanyag) x) where 
  uzemanyag x = x/3-2 + uzemanyag (x/3-2)
"""
