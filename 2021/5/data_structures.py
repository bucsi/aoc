class Multiset:
    def __init__(self):
        self.dict = {}
        self.items = []
    
    def add(self,item):
        hash = item.__hash__()
        if hash in self.dict:
            self.dict[hash] += 1
        else:
            self.dict[hash] = 1
            self.items.append(item)
    
    def print_counts(self):
        for item in self.items:
            print(item, self.dict[item.__hash__()])
    
    # return the number of items where the given item occurs more or equal than n times
    def get_count_more_than(self,n):
        count = 0
        for item in self.items:
            if self.dict[item.__hash__()] >= n:
                count += 1
        return count
