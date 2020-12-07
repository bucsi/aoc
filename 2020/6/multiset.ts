type TSetData = {
    [key: string]: number,
}

export class MultiSet {
    protected data: TSetData
    constructor() {
        this.data = {}
    }

    add(ch: string) {
        this.data[ch] ? this.data[ch]++ : (this.data[ch] = 1)
    }
    /**
     * The number of unique elements in the multiset
     */
    public get unique() {
        return Object.keys(this.data).length
    }

    /**
     * The number of all elements in the multiset
     */
    public get size() {
        return Object.values(this.data).reduce((sum, cur) => (sum += cur), 0)
    }
}
