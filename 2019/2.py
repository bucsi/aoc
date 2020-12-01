noun = 0
verb = 0
cycle = 1

def get_input(filename):
    with open(filename, "r") as f:
        return f.read().split(",")

program = [int(n) for n in get_input("2.txt")]
prog = program.copy()

i = 0
while(prog[i] != 99):
    x = prog[prog[i+1]]
    y = prog[prog[i+2]]
    p = prog[i+3]
    if(prog[i] == 1):
        prog[p] = x+y
    elif(prog[i] == 2):
        prog[p] = x*y
    else:
        print(f"Hiba az {i}. mezoben: {prog[i]}")
    i += 4
print("First solution:", prog[0])

while(1):
    prog = program.copy()
    prog[1] = noun
    prog[2] = verb
    
    i = 0
    while(prog[i] != 99):
        x = prog[prog[i+1]]
        y = prog[prog[i+2]]
        p = prog[i+3]
        if(prog[i] == 1):
            prog[p] = x+y
        elif(prog[i] == 2):
            prog[p] = x*y
        else:
            print(f"Error at mem {i}. Value: {prog[i]}")
        i += 4
    if(prog[0] == 19690720):
        print(f"At the {cycle}th repeat, i found: {noun} & {verb} -> {prog[0]} (second solution)")
        break
    else:
        cycle += 1
        noun += 1
        if noun == 100:
            verb += 1
            noun = 0
            if verb == 100:
                print("No solution found for noun,verb 0..99")
                break