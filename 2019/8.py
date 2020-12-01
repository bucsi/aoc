from collections import Counter

def get_input(filename):
    with open(filename, "r") as f:
        return f.read()

def countNum(layer, search_key):
    count = 0
    for row in layer:
        count += Counter(row)[search_key]
    return count


pic = get_input("8.SIF")
pic = [pic[i:i+25] for i in range(0, len(pic), 25)] #group at every 25 char
pic = [pic[i:i+6] for i in range(0, len(pic), 6)] #group at every 6 groups

nulls = 9999999
nulls_pos = 0

for i,layer in enumerate(pic):
    if countNum(layer, "0") < nulls:
        nulls_pos = i
for row in pic[i]:
    print(row)

print(numof1s := countNum(pic[i], '1'))
print(numof2s := countNum(pic[i], '2'))
print(numof1s * numof2s)