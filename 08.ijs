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
NB. a,"0 i.b ==> a 0,a 1,...,a b
NB. f builds a string (0,"0 i.y),(1,"0 i.y),...(Y,"0 i.y)  (Y being the top value)
NB. g interprets that as a verb
NB. call g with the required size to build the full list of indices required.
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

NB. calculate scenic score. Relies on global n, pass in y = i j
scenic =. 3 : 0
i=.0{y
j=.1{y
t=. i{j{n          NB. the height of this tree
tl=. |.i{.j{n      NB. viewing left (so reversed)
tr=. (i+1)}.j{n    NB. viewing right
tu=. |.j{.i{"1 n   NB. viewing up (reversed)
td=. (j+1)}.i{"1 n NB. viewing down

(t ct tl) * (t ct tr) * (t ct tu) * (t ct td)
)

ct =: 4 : 0 NB. ct=count trees. Call as <this> ct <list of heights>, e.g. 5 ct 3 5 2
NB. 5 ct 5 2 9 => 1; 5 ct 2 1 6 => 3; 5 ct 1 1 1 => 3; 5 ct '' => 0
(#y) <. (1 + ((x > y) i. 0)) NB. 1+ because i. is 0-indexed; min vs #y as otherwise we are 1 too high if t higher than all
)

echo >./ scenic"1 is

exit 0
