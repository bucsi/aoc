import { MultiSet } from "./multiset.ts"

type TSolution = {
    part1: number
    part2: number
}

class CustomsForms extends MultiSet {
    n: number

    /**
     * @param people The number of people in the group filling out the form
     */
    constructor(people: number) {
        super()
        this.n = people
    }

    public get allFilledYes() {
        return Object.values(this.data).filter(v => v === this.n).length
    }
}

Deno.readTextFile("./6.txt")
    .then(t => t.split("\n\n"))
    .then(arr => arr.map(el => el.split("\n")))
    .then(strarr => strarr.map(createSet))
    .then(sets =>
        sets.reduce<TSolution>(
            (sum, cur) => {
                sum.part1 += cur.unique
                sum.part2 += cur.allFilledYes
                return sum
            },
            { part1: 0, part2: 0 }
        )
    )
    .then(res => console.log(res))

const createSet = (arr: string[]) => {
    let set = new CustomsForms(arr.length)
    arr.forEach(t => [...t].forEach(ch => set.add(ch)))
    return set
}
