let part = 1 // set to 2 to enable extra verification - counts ONE MORE correct items than the actual solution

const ecls = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

Deno.readTextFile("./4.txt")
    .then(text => text.split("\n\n"))
    .then(arr => arr.map(el => el.split(/\s|\n/)))
    .then(arr => arr.reduce(logic, 0))
    .then(res => console.log(res))

const logic = (total: number, current: string[]) => {
    if (valid(current)) return total + 1
    else return total
}

const valid = (current: string[]) => {
    if (part === 1) {
        return current.length === 8 || (current.length === 7 && !current.some(el => el.includes("cid:")))
    }
    if (!(current.length === 8 || (current.length === 7 && !current.some(el => el.includes("cid:"))))) {
        return false
    }
    for (let row of current) {
        let field = row.substring(0, 3)
        let value = row.substring(4)
        let numericValue = parseInt(value)
        if (field === "byr") {
            if (!(!isNaN(numericValue) && 1920 <= numericValue && numericValue <= 2002)) return false
        } else if (field === "iyr") {
            if (!(!isNaN(numericValue) && 1920 <= numericValue && numericValue <= 2020)) return false
        } else if (field === "eyr") {
            if (!(!isNaN(numericValue) && 2020 <= numericValue && numericValue <= 2030)) return false
        } else if (field === "hgt") {
            numericValue = parseInt(value.substring(0, value.length - 2))
            let measurement = value.slice(-2)

            if (measurement === "cm") {
                if (!(!isNaN(numericValue) && 150 <= numericValue && numericValue <= 193)) return false
            } else if (measurement === "in") {
                if (!(!isNaN(numericValue) && 59 <= numericValue && numericValue <= 76)) return false
            } else {
                return false
            }
        } else if (field === "hcl") {
            if (value.match(/^#[0-9a-f]{6}/i) === null) return false
        } else if (field === "ecl") {
            if (!ecls.includes(value)) return false
        } else if (field === "pid") {
            if (!(value.length === 9)) return false
        }
    }
    return true
}
