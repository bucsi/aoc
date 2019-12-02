noun = 0
verb = 0
output = 0
cycle = 1

while(1):
    prog = [int(n) for n in "1,100,100,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,9,19,1,5,19,23,1,6,23,27,1,27,10,31,1,31,5,35,2,10,35,39,1,9,39,43,1,43,5,47,1,47,6,51,2,51,6,55,1,13,55,59,2,6,59,63,1,63,5,67,2,10,67,71,1,9,71,75,1,75,13,79,1,10,79,83,2,83,13,87,1,87,6,91,1,5,91,95,2,95,9,99,1,5,99,103,1,103,6,107,2,107,13,111,1,111,10,115,2,10,115,119,1,9,119,123,1,123,9,127,1,13,127,131,2,10,131,135,1,135,5,139,1,2,139,143,1,143,5,0,99,2,0,14,0".split(",")]
    prog[1] = noun
    prog[2] = verb
    
    i = 0
    while(prog[i] != 99):
        x = prog[prog[i+1]]
        y = prog[prog[i+2]]
        p = prog[i+3]
        #print(f"Utasitas-sorozat: {prog[i:i+4]}\t-> az {i+1}. szamot (erteke:{x}) és az {i+2}. szamot(erteke:{y}) fogom {p}-ba/be kiszamolni")
        if(prog[i] == 1):
            prog[p] = x+y
        elif(prog[i] == 2):
            prog[p] = x*y
        else:
            print(f"Hiba az {i}. mezoben: {prog[i]}")
        i += 4
    print(f"{cycle}.ism:\t{noun}, {verb} -> {prog[1]}")
    if(prog[1] == 19690720):
        break
    else:
        cycle += 1
        noun += 1
        if noun == 100:
            verb += 1
            noun = 0
            if verb == 100:
                print("Tulmentem.")
                break