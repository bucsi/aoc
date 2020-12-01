def get_input(filename):
    with open(filename, "r") as f:
        return [x.split(")") for x in f.read().split("\n")]

class planet:
    name = "undefined"
    parent = "undefined"

    def __init__(self, name, parent):
        self.name = name
        self.parent = parent
    
    def __repr__(self):
        return f"{self.parent} is orbited by {self.name}"

COM = planet("COM", "undefined")
l = []

for asd in ["A", "B", "C"]:
    l.append(planet(asd, "COM"))


print(l)
