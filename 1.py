def calculate(mass):
    if mass < 6:
        return 0
    return int(mass/3-2) + calculate(int(mass/3-2))

with open("1.txt", "r") as infile:
    print("First part solution: ", sum([int(int(x)/3)-2 for x in infile.readlines()]))
    print("Second part solution: ", sum([calculate(int(x)) for x in infile.readlines()]))
