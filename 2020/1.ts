const input = await Deno.readTextFile("./1.txt").then(r => r.split("\n").map(el => parseInt(el)))

for (let i = 0; i < input.length; i++) {
    for (let j = i + 1; j < input.length; j++) {
        if (input[i] + input[j] === 2020) {
            console.log(`Two numbers solution: ${input[i] * input[j]}`)
        }
        for (let k = j + 1; k < input.length; k++) {
            if (input[i] + input[j] + input[k] === 2020) {
                console.log(`Three numbers solution: ${input[i] * input[j] * input[k]}`)
            }
        }
    }
}


export {}