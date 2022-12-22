import sys
from typing import Callable

class Monkey:
    items: list
    op: Callable
    test: int
    true: int
    false: int
    inspected: int

    def __init__(self, defn: str):
        lines = defn.split('\n')
        self.items = [int(x) for x in lines[1].split(':')[1].split(', ')]
        self.op = eval("lambda old: " + lines[2].split('=')[1])
        self.test = int(lines[3].split(' ')[-1])
        self.true = int(lines[4].split(' ')[-1])
        self.false = int(lines[5].split(' ')[-1])
        self.inspected = 0

def solve(rounds, div_3):
    monkeys = []
    fname = '11.txt' if len(sys.argv)==1 else sys.argv[1]
    with open(fname) as f:
        monkeys = [Monkey(s) for s in f.read().split("\n\n")]

    tests = [m.test for m in monkeys]
    from math import prod
    maxx = prod(tests)

    for _round in range(rounds):
        for monkey in monkeys:
            while monkey.items:
                item = monkey.items.pop(0)
                monkey.inspected += 1
                newval = monkey.op(item)
                if div_3: newval //= 3
                else: newval %= maxx
                to = monkeys[monkey.true] if newval % monkey.test == 0 else monkeys[monkey.false]
                to.items.append(newval)

        if False:
            print("Round: ", _round)
            for monkey in monkeys:
                print(", ".join([str(item) for item in monkey.items]))

    active = sorted(monkeys, key=lambda monkey: monkey.inspected, reverse=True)
    return active[0].inspected * active[1].inspected

print(solve(20, True))
print(solve(10000, False))
