instr =. <;._2 freads '10.txt'

NB. Take instructions and output list of cycles and increment at those cycles
NB. noop, addx 1, addx 2, noop, addx 3 => 1 0 0 1 0 2 0 0 3
NB. 1 = starting value (cycle 0); noop => 0; addx x => 0 x
parse =. 3 : 0
a=.1
for_ijk. y do.
	op =. >ijk
	if. (4{.op) -: 'noop' do.
		a=. a,0
	else.
		a=.a, 0,". 5}.op
	end.
end.
a
)

ops =. parse instr
reg_values =. +/\ ops
cycles =. 20 60 100 140 180 220
echo +/ cycles * (cycles -1){reg_values  NB. -1 because increment happens at end of cycle

NB. part two
ce =: 4 : 0 NB. ce = close enough - one up or down
(x >: y-1) *. (x <: y+1)
)

scan =. 3 : 0
(i.$y) ce y
)

echo (scan"1 ] 6 40 $ reg_values) { ' #'

exit 0
