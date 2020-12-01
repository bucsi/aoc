from collections import Counter

def get_input(filename):
    with open(filename,'r') as f:
        return f.read().split("-")

def hasDupe(n):
    n = list(str(n))
    for i in range(len(n)-1):
        if n[i] == n[i+1]:
            return True
    return False

def hasSingleDupe(n):
    return 2 in Counter(list(str(n))).values()

def hasDecrease(n):
    n = list(str(n))
    for i in range(len(n)-1):
        if n[i] > n[i+1]:
            return True
    return False

def validNumber1(n):
    return hasDupe(n) and not hasDecrease(n)

def validNumber2(n):
    return hasSingleDupe(n) and not hasDecrease(n)

btm, top = get_input("4.txt")
print("Part 1: ",len([x for x in range(int(btm),int(top)+1) if validNumber1(x)]))
print("Part 2: ",len([x for x in range(int(btm),int(top)+1) if validNumber2(x)]))