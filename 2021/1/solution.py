with open("input", "r") as in_file:
    data = [int(x.strip()) for x in in_file.readlines()]
print(f"Number of measurements where the current one is deeper (greater number) than the previous: {sum([1 if last < curr else 0 for last, curr in zip(data, data[1:])])}")

window_sums = [sum(x) for x in zip(data, data[1:], data[2:])]
print(f"Number of three-measurement windows where the current one is deeper (greater number) than the previous: {sum([1 if last < curr else 0 for last, curr in zip(window_sums, window_sums[1:])])}")

