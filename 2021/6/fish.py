class Fishies:
    def __init__(self, list):
        self.day = 0
        self.dict = {
            0:0,
            1:0,
            2:0,
            3:0,
            4:0,
            5:0,
            6:0,
            7:0,
            8:0
        }
        for fish in list:
            self.dict[fish] += 1
    
    def inc_day(self):
        new_dict = {
            0:self.dict[1],
            1:self.dict[2],
            2:self.dict[3],
            3:self.dict[4],
            4:self.dict[5],
            5:self.dict[6],
            6:self.dict[7]+self.dict[0],
            7:self.dict[8],
            8:self.dict[0]
        }

        self.dict = new_dict
    
    def __len__(self):
        return sum(self.dict.values())
    
    def __repr__(self):
        return str(self.dict) + "\n Number of fish: " + str(len(self))
