def get_input(filename):
    with open(filename, "r") as f:
        return f.read().split(",")

def get_params(mode, op_addr, param_position, program):
    if mode == "1":
        # immediate mode
        return program[op_addr + param_position]
    elif mode == "0":
        # position mode
        return program[program[op_addr + param_position]]

def unpack_opcode(opcode):
    opcode = str(opcode)
    while(len(opcode) < 5):
        opcode = "0" + opcode
    return opcode[-2:], opcode[-3], opcode[-4], opcode[-5]

prog = [int(n) for n in get_input("5.txt")]
step = 4

prev_i = -9
i = 0
halt = False
while(not halt):
    op, mode_of_p1, mode_of_p2, mode_of_p3 = unpack_opcode(prog[i])
    print(f"\t\t\tDEBUG: startig operation at addr {i}")
    print(f"\t\t\tDEBUG: {op, mode_of_p1, mode_of_p2, mode_of_p3} unpacked from {prog[i]}")
    if op in ["01","02"]:
        # + or *
        x = get_params(mode_of_p1, i, 1, prog)
        y = get_params(mode_of_p2, i, 2, prog)
        p = get_params("1", i, 3, prog)
        print(f"\t\t\tDEBUG: {prog[i:i+4]} -> {op, x, y, p}")
        if op == "01":
            prog[p] = x+y
        else:
            prog[p] = x*y
        step = 4
    elif op in ["03","04"]:
        # in/output
        p = get_params('1', i, 1, prog)
        print(f"\t\t\tDEBUG: {prog[i:i+2]} -> {op, p}")
        if op == "03":
            prog[p] = int(input(f"INPUT (to addr {p}): "))
        else:
            print(f"OUT: addr {p} is {prog[p]}")
        step = 2
    elif op in ["05", "06"]:
        # GOTO
        x = get_params(mode_of_p1, i, 1, prog)
        p = get_params(mode_of_p2, i, 3, prog)
        print(f"\t\t\tDEBUG: {prog[i:i+3]} -> {op, x, p}")
        print("the instruction pointer went from", i, end=" ")
        if op == "05":
            if prog[x] != 0:
                i = p
        else:
            if prog[x] == 0:
                i = p
        print("to", i)
        continue
    elif op in ["07","08"]:
        # compare
        x = get_params(mode_of_p1, i, 1, prog)
        y = get_params(mode_of_p2, i, 2, prog)
        p = get_params("1", i, 3, prog)
        print(f"\t\t\tDEBUG: {prog[i:i+4]} -> {op, x, y, p}")
        if op == "07":
            if x < y:
                prog[p] = 1
            else:
                prog[p] = 0
        else:
            if x == y:
                prog[p] = 1
            else:
                prog[p] = 0
        step = 4
    elif(op == "99"):
        print("----- H A L T -----")
        halt = True
    else:
        print(f"ERR: Unknown op ({prog[i]}) at position {i}")
    prev_i = i
    i += step
    if i == prev_i:
        print("Terminating infinite loop")
        break
