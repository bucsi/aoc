from copy import deepcopy

with open("./sample2.txt", "r") as inf:
    data = [line.strip() for line in inf.readlines()]

# for line in data:
#     print(line.split(""))




def part1(data):
    data = [list(line) for line in data]
    data = [list(filter(lambda s: s.isnumeric(), line)) for line in data]
    data = [str(line[0] + line[-1]) for line in data]
    data = [int(item) for item in data]
    print(f"part 1 {sum(data)}")

def transmorgify(string: str):
    start = 5, end = 9
    substr1 = string[0:4]
    while(end < len(string)-1):
        substr2 = string[start:end]
        
    # return string  \
    #     .replace("one", "1") \
    #     .replace("two", "2") \
    #     .replace("three", "3") \
    #     .replace("four", "4") \
    #     .replace("five", "5") \
    #     .replace("six", "6") \
    #     .replace("seven", "7") \
    #     .replace("eight", "8") \
    #     .replace("nine", "9") \

def part2(data):
    data = [transmorgify(line) for line in data]
    print(data)


# part1(deepcopy(data))
part2(data)