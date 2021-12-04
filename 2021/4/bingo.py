def pad(string):
    return string.ljust(2)


class BoardCell:
    def __init__(self):
        self.value = ""
        self.checked = False

    def __repr__(self):
        marker = "*" if self.checked else " "
        return f"({marker}{self.value}{marker})"


class Board:
    def __init__(self):
        self.board = [[BoardCell() for x in range(5)] for x in range(5)]
        self._next_row = 0
        self.active = True

    def __repr__(self):
        ret = "\n----------------------------\n"
        for row in self.board:
            ret += "|"
            for cell in row:
                marker = "*" if cell.checked else " "
                ret += f" {marker}{cell.value.rjust(2)}{marker}"
            ret += " |\n"
        ret += "----------------------------\n"
        return ret

    def fill_next_row(self, list):
        for i in range(len(list)):
            self.board[self._next_row][i].value = list[i]
        self._next_row += 1

    def mark(self, num) -> bool:
        for i in range(len(self.board)):
            for j in range(len(self.board[i])):
                if self.board[i][j].value == num:
                    self.board[i][j].checked = True
                    return True
        return False

    # checks all rows and cols and tells if one of them is fully checked
    def check_win(self) -> bool:
        for i in range(len(self.board)):
            if self._check_row(i) or self._check_col(i):
                return True
            # if self._check_diag_lr() or self._check_diag_rl():
            # return True
        return False

    def _check_row(self, row) -> bool:
        for i in range(len(self.board[row])):
            if not self.board[row][i].checked:
                return False
        return True

    def _check_col(self, col) -> bool:
        for i in range(len(self.board)):
            if not self.board[i][col].checked:
                return False
        return True

    # checks if left to right diagonal is checked
    def _check_diag_lr(self) -> bool:
        for i in range(len(self.board)):
            if not self.board[i][i].checked:
                return False
        return True

    # checks if right to left diagonal is checked
    def _check_diag_rl(self) -> bool:
        for i in range(len(self.board)):
            if not self.board[i][len(self.board) - i - 1].checked:
                return False
        return True

    def _sum_row(self, row):
        return sum([int(x.value) for x in row if not x.checked])

    def sum(self):
        return sum([self._sum_row(x) for x in self.board])

    def destroy(self):
        self.active = False
