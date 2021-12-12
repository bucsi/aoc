class Point:
    def __init__(self, string):
        self.x, self.y = [int(x) for x in string.split(",")]

    def __repr__(self):
        return f"({self.x},{self.y})"

    def __hash__(self):
        return hash((self.x, self.y))

    def __lt__(self, other):
        return (self.x, self.y) < (other.x, other.y)

class Line:
    def __init__(self, string):
        points = [Point(x) for x in string.split(" -> ")]
        self.start = min(points)
        self.end = max(points)
    
    def is_vertical(self):
        return self.start.x == self.end.x

    def is_horizontal(self):
        return self.start.y == self.end.y
    
    def gen_points(self):
        if self.is_vertical():
            for y in range(self.start.y, self.end.y + 1):
                yield Point(f"{self.start.x},{y}")
        elif self.is_horizontal():
            for x in range(self.start.x, self.end.x + 1):
                yield Point(f"{x},{self.start.y}")
        else:
            #diagonal line
            x_step = 1 if self.start.x < self.end.x else -1
            y_step = 1 if self.start.y < self.end.y else -1
            x = self.start.x
            y = self.start.y
            while x != self.end.x or y != self.end.y:
                yield Point(f"{x},{y}")
                x += x_step
                y += y_step

    def __repr__(self):
        return f"{self.start} -> {self.end}"

    def __hash__(self):
        return hash((self.p1, self.p2))
