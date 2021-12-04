from collections import Counter
from typing import Union

with open("input") as f:
    data = [list(x.strip()) for x in f.readlines()]
# transpose data
transposed = list(zip(*data))
# get most frequent element from each list in transposed
gamma_rate = [max(set(x), key=x.count) for x in transposed]
epsilon_rate = ["1" if x == "0" else "0" for x in gamma_rate]
# create decimal number from binary in gamma_rate
gamma_result = int("".join(gamma_rate), 2)
# create  decimal number from binary in epsilon_rate
epsilon_result = int("".join(epsilon_rate), 2)

print(f"The solution for the first task is {gamma_result*epsilon_result}")

# find most common element in column j of a matrix
def most_common(
    matrix: list[list[str]], j: int, return_when_equal: Union["0", "1"]
) -> str:
    # get column j
    col = [row[j] for row in matrix]
    # put col into counter
    multiset = Counter(col)
    if multiset["0"] == multiset["1"]:
        return return_when_equal
    else:
        return max(set(col), key=col.count)


curr_bit = 0
# create deep copy of data
data_copy = data[:]
# print("\n\n\n" + repr(data_copy))
while len(data_copy) != 1:
    # filter out elements from data where the curr_bit element is not equal to the most common element in the curr_bit coloumn
    data_copy = [
        x for x in data_copy if x[curr_bit] == most_common(data_copy, curr_bit, "1")
    ]
    # print(data_copy)
    curr_bit += 1
o2_gen_rating = int("".join(data_copy[0]), 2)

curr_bit = 0
# create deep copy of data
data_copy = data[:]
# print("\n\n\n" + repr(data_copy))
while len(data_copy) != 1:
    # filter out elements from data where the curr_bit element is not equal to the least common element in the curr_bit coloumn
    common = most_common(data_copy, curr_bit, "1")
    rare = "1" if common == "0" else "0"
    # print(f"{data_copy}\nat bit {curr_bit}, most common is {common}, keeping {rare}")
    data_copy = [x for x in data_copy if x[curr_bit] == rare]
    curr_bit += 1
co2_scrubber_rating = int("".join(data_copy[0]), 2)
print(f"The solution for the second task is {o2_gen_rating*co2_scrubber_rating}")
