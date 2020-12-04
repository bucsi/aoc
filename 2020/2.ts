let text = Deno.readTextFile("./2.txt")

text.then(r => r.split("\n"))
    .then(a =>
        a.reduce((total, curr) => {
            let [min, max, char, passwd] = converter(curr.split(/-|\s|:/))
            let count = (passwd.match(new RegExp(char, "g")) || []).length
            return total + (min <= count && count <= max ? 1 : 0)
        }, 0)
    )
    .then(res => console.log(`Valid passwords for task 1: ${res}`))

text.then(r => r.split("\n"))
    .then(a =>
        a.reduce((total, curr) => {
            let [pos1, pos2, char, passwd] = converter(curr.split(/-|\s|:/))
            return total + ((passwd[pos1 - 1] === char) !== (passwd[pos2 - 1] === char) ? 1 : 0)
        }, 0)
    )
    .then(res => console.log(`Valid passwords for task 2: ${res}`))

let converter = (arr: Array<string>): [number, number, string, string] => [
    parseInt(arr[0]),
    parseInt(arr[1]),
    arr[2],
    arr[4]
]


export {}