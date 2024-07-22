import gleam/regex

pub type Dir {
  L
  R
}

pub type Instruction {
  Instruction(direction: Dir, next: Instruction)
}

pub type Node {
  Node(name: String, left: Node, right: Node)
  NotConfigured
}

pub fn parse(input: String) {
  todo
}

pub fn pt_1(input: String) {
  todo as "part 1 not implemented"
}

pub fn pt_2(input: String) {
  todo as "part 2 not implemented"
}
