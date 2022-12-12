input =. freads '03.txt'

NB. Split into boxes based on newline
test =. 'vJrwpWtwJgWrhcsFMMfFFhFp';'jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL';'PmmdzqPrVvPwwTWBwg';'wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn';'ttgJtRGJQctTZtZT';'CrZsJsPPZsGzwwsLwLmpwMDw'

NB. Method to split a line in two, and then find the common character
split =. 3 : 0
size =. ($y) %2
both =. (-size) [\ ( size {. y ) , ( (-size) {. y )
0{both
)

common =. 3 : 0
y1 =. 0{split y
y2 =. 1{split y
NB. see `d8` from https://www.jsoftware.com/help/phrases/locate_select.htm
(y1 (e.i.1:) y2) { y1  
)

NB. Method to convert character to value

NB. sum of values of common chars of split lines of boxes of input


exit 0
