input =. freads '04.txt'
lines =. <;._2 input

NB. ',' v '1-3,2-12' => [ '1-3' ; '2-12' ]
split_on_chr =: 4 : 0
y =. >y
ix =. y (e.i.1:) x
NB. (ix{.y) ; ( (($y) - ix) }.y)
(ix{.y) ; ( (ix+1) }.y)
)

ranges =. 3 : 0
y =. >y
pair =. ',' split_on_chr y
l =. '-' split_on_chr 0{pair
r =. '-' split_on_chr 1{pair
l_range =. (".>0{l)}.i.(".>1{l)+1
r_range =. (".>0{r)}.i.(".>1{r)+1
l_range ; r_range
)

contains =. 3 : 0
l =. >0{y
r =. >1{y
maxlen =. >./ ($l),($r)
maxlen = $~.l,r
)

overlaps =. 3 : 0
l =. >0{y
r =. >1{y
-. (($l) + ($r)) = $~.l,r
)

echo +/ contains "1 ranges "0 lines NB. Part one
echo +/ overlaps "1 ranges "0 lines NB. Part two

exit 0
