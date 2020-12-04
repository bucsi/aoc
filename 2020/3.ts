export {}
const input = await Deno.readTextFile("./3.txt").then(r => r.split("\n"))

for(let i=0; i<input.length; i++){
    input[i] = input[i].slice(0,-1)
}

const len = input[0].length-1;
for(let c of input[0]){
    console.log(c)
}
console.log(`${len} hosszú egy sor`)
let pos = 0
let trees = 0

for(const line of input){
    console.log(`${line} (${pos})`)
    console.log(`${" ".repeat(pos)}^`)
    if(line[pos] === "#") trees++
    pos += 3
    if(pos > len){
        const offset = pos-len-1
        pos = 0
        pos += offset
    }
}

console.log(trees)