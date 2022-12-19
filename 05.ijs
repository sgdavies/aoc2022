lines =. <;._2 freads '05.txt' NB. Boxed

NB. Split the input into the starting arrangement & instructions
blank =. +/ (lines = <'') * i. $lines NB. Horrendous way to get the index of the empty box!
starting =. >(blank-1){.lines NB. drop the final line - the stack numbers
NB. > has auto-filled the shorted lines in starting with blanks
NB. So it looks like this (with . instead of space for visibility):
NB. ....[D]....
NB. [N].[C]....
NB. [Z].[M].[P]
NB. 01234567890 (indices)
NB. Single-char labels (phew!) are at 1, 5, 9 --> 1+4*n
column_indices =. 1 + 4 * i. +<.(1+1{$starting)%4 NB. 1 5 9 ... = 1+4*(rounded down length of line/4)
start_stacks =. |: column_indices {"1 starting NB. .NZ,DCM,..P
rotate_spaces =. 3 : 0
padded =. ' ',y
last_space =. padded i: ' '
($y){. (1+last_space) |. padded
)
NB. No -- I'd be better to just cull and then box (and maybe reverse) - I can't put more items on stack P..... anyway.
NB. usedtocull =: 1 : 'u # ]'
NB. max_stack=. $' ' ~:  usedtocull ,start_stacks NB. Max depth if everything ends up on same stack
NB. Rotated and then padded at the end: NZ....,DCM...,P.....
NB. stacks=.max_stack{."1 (rotate_spaces "1 start_stacks) ,"1 max_stack {.!. ' ' ''
stacks =: ;/ rotate_spaces "1 start_stacks NB. NZ.;DCM;P.. -- top of stack is at the front of each list.
NB. The right padding is not wanted, but harmless

NB. OK, now we have our stacks! Time to parse the input and do something useful.
instructions =. >(blank+1)}.lines

NB. x = true to move one-by-one, false to move as block; y = instructions;stack
f =. 4 : 0
onebyone =. x
NB. echo y
instructions =. >0{y
NB. echo instructions
stack =: > 1{y
NB. echo stack
for_ijk. instructions do.
	NB. echo ijk
	nums =. 0 ".> ;: ijk  NB. 'Move 1 from 2 to 3' -> 0 1 0 2 0 3
	num =. 1{nums
	fi =. _1 + 3{nums NB. -1 because stack boxes are 0-indexed
	ti =. _1 + 5{nums
	from =. num}.>fi{stack NB. drop fi from front (top) of stack
	if. onebyone do.
		to =. (|. num{.>fi{stack),>ti{stack NB. ...append same to front of other stack - reversed (=1-by-1)
	else.
		to =. (num{.>fi{stack),>ti{stack NB. not reversed.
	end.

	stack =: (fi{.stack),from;(fi+1)}.stack NB. replace old val with new
	stack =: (ti{.stack),to;(ti+1)}.stack
	NB. echo stack
end.
0 {"1 >stack
)

echo 1 f instructions;<stacks
echo 0 f instructions;<stacks

exit 0
