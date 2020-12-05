export {}
const input = await Deno.readTextFile("./3.txt").then(r => r.split("\n"))


const len = input[0].length-2;
console.log(`Rowlength is: ${len}`)


const positions = [0,0,0,0,0]
const trees = [0,0,0,0,0]

/*
0 right 1 down 1
1 right 3 down 1
2 right 3 down 1
3 right 3 down 1
4 right 1 down 2

*/

for(let i=0; i<input.length; i++){
    let line = input[i].slice(0,-1)
    for(let p=0; p<4; p++){
        if(line[positions[p]] === "#") trees[p]++
    }
    if(i%2===0){
        if(line[positions[4]] === "#") trees[4]++
        positions[4]+=1
    }
    positions[0] += 1
    positions[1] += 3
    positions[2] += 5
    positions[3] += 7
    for(let p=0; p<=4; p++){
        if(positions[p] > len){
            positions[p] = 0 + positions[p]-len-1
        }
    }
}

console.log(`Trees found when going right 3 down 1: ${trees[1]}`)
console.log(`Trees found in all directions: ${trees}`)
console.log(`Task 2 solution is: ${trees.reduce((p,e)=>p*=e)}`)