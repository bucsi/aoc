from functools import reduce

with open("input", "r") as f:
    sum_easy_digits = 0
    for line in [x.strip() for x in f]:
        patterns, output = line.split(" | ")
        patterns = patterns.split(" ")
        output = output.split(" ")
        easy_digits = []
        for p in patterns:
            match(len(p)):
                case 2:
                    #print(f"* {p}{(9-len(p))*' '}-> 1")
                    easy_digits.append(sorted(p))
                case 3:
                    #print(f"* {p}{(9-len(p))*' '}-> 7")
                    easy_digits.append(sorted(p))
                case 4:
                    #print(f"* {p}{(9-len(p))*' '}-> 4")
                    easy_digits.append(sorted(p))
                case 5:
                    pass
                    #print(f"  {p}{(9-len(p))*' '}-> 2 or 5")
                case 6:
                    pass
                    #print(f"  {p}{(9-len(p))*' '}-> 0 or 6 or 9")
                case 7:
                    #print(f"* {p}{(9-len(p))*' '}-> 8")
                    easy_digits.append(sorted(p))
        #print(output)
        easy_digits_in_line = reduce(lambda s,x: s+1 if sorted(x) in easy_digits else s, output, 0)
        sum_easy_digits += easy_digits_in_line
        #print(f"{easy_digits_in_line} easy digits in line\n")
print(sum_easy_digits)
