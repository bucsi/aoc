with open("input.txt") as infile:
    elf_calories = [[int(calories) for calories in elf.split("\n")]
                    for elf in infile.read().split("\n\n")]

print(f"Most calories: {max(map(sum, elf_calories))}")
print(
    f"Sum of top 3: {sum(sorted(map(sum, elf_calories), reverse=True)[0:3])}")
