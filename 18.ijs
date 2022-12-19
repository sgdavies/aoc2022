input =. freads '18.txt'
lines =. <;._2 input

NB. faces (a b c) creates a list of the six faces of cube a,b,c
faces=. 3 : 0
a=.0{y
b=.1{y
c=.2{y
x=.(a-0.5), b, c
x=.x,:(a+0.5), b, c NB. ,: because we want (ijk, abc) not (ijkabc)
x=.x,a, (b-0.5), c  NB. but now just , because the shape is fixed
x=.x,a, (b+0.5), c
x=.x,a, b, (c-0.5)
x=.x,a, b, (c+0.5)
x
)

to_nums =. 3 : 0
y=.>y
". ];._1 ',' , y
)

echo +/ 1= +/"1 = ,/,/faces"1 to_nums "1 lines
exit 0
