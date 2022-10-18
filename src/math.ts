import { create, all } from 'mathjs'

const mathjs = create(all);
mathjs.config({
    number: 'BigNumber',
    precision: 64,
    epsilon: 1e-60
})

export default mathjs;