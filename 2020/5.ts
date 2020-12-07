const rowcol = (partitioning: string): { row: number; col: number } => {
    let lo = 0
    let hi = 127
    let mid = 64
    let ret = { row: -1, col: -1 }
    for (let i = 0; i < 7; i++) {
        mid = lo + Math.ceil((hi - lo) / 2)
        if (partitioning[i] === "F") {
            hi = mid - 1
        } else {
            lo = mid
        }
    }
    ret.row = lo
    lo = 0
    hi = 7
    for (let i = 7; i < 10; i++) {
        let mid = lo + Math.ceil((hi - lo) / 2)
        if (partitioning[i] === "L") {
            hi = mid - 1
        } else {
            lo = mid
        }
    }
    ret.col = lo
    return ret
}

const cfn = (a: number, b: number) => a - b

let ids = Deno.readTextFile("./5.txt")
    .then(t => t.split("\n"))
    .then(arr => arr.map(el => rowcol(el)))
    .then(arr => arr.map(el => el.row * 8 + el.col))

ids.then(arr => Math.max(...arr)).then(res => console.log(`Highest seat id: ${res}`))

let sorted = await ids.then(arr => arr.sort(cfn))
for (let i = 0; i < sorted.length; i++) {
    if (sorted[i] + 1 !== sorted[i + 1]) {
        console.log(`My seat id: ${sorted[i] + 1}`)
        break
    }
}