lines =. <;._2 freads '08.txt'
n=: "."0 >lines  NB. Global so 'gany' function works...

NB. Can't get this to work - can't get the rank correct.
fany =: 4 : 0 NB. n fany i j
i=.0{y
j=.1{y
n=.x
fl =. i = +/ (i{j{n) > (i{.j{n)
fr =. (($(j{n))-i+1) = +/ (i{j{n) > ((i+1)}.j{n)
fa =. j = +/ (j{i{"1 n) > (j{.i{"1 n)
fb =. (($(i{"1 n))-j+1) = +/ (j}i}"1 n) > ((j+1)}.i{"1 n)
0 < fl+fr+fa+fb NB. At least one is true
)

gany =: 3 : 0 NB. (global n) gany i j
i=.0{y
j=.1{y
fl =. i = +/ (i{j{n) > (i{.j{n)
fr =. (($(j{n))-i+1) = +/ (i{j{n) > ((i+1)}.j{n)
fa =. j = +/ (j{i{"1 n) > (j{.i{"1 n)
fb =. (($(i{"1 n))-j+1) = +/ (j}i}"1 n) > ((j+1)}.i{"1 n)
0 < fl+fr+fa+fb NB. At least one is true
)

NB. Just want a list of indices - e.g. 0 0,0 1,...,1 0, 1 1, ...
NB. Horrible hack to create this - build an expr from strings
NB. f creates each 'row' then g repeats it
f=. 3 : 0
s=.'(0,"0 i.',(":y),')'
x=.1
while. x < y do.
 s=.s, ',(', (":x), ',"0 i.', (":y), ')'
 x=. x+1
end.
s
)

g =. 3 : (f #n)
is =. g #n NB. the list of indices I wanted

NB. Now run the algo over the indices list
echo +/ gany"1 is

exit 0
