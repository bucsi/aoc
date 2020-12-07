import { MultiSet } from "./multiset.ts";

let s = new MultiSet();

s.add("a");
s.add("b");
s.add("a");

console.log(s.size, s.occurences);