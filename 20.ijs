input =. 1 2 _3 3 _2 0 4
input =. ". ;._2 freads '20.txt'

solve =. 4 : 0
arr =. i.#y

for. i.x do.
  for_a. i.#y do.
    pos =. arr i. a
    val =. a{y
    arr =. pos |. arr
    if. val < 0 do.
      s =. (_1+#arr) | -val
      arr =. a, (-s) |. }.arr
    else.
      s =. (_1+#arr) | val
      arr =. a, s |. }.arr
    end.
    NB.echo  x, val, pos, _, arr, _, arr{y
  end.
  NB.echo arr { y
end.
arr { y
)

print_ans =. 3 : 0
zero =. y i. 0
a1 =. ((#y) | zero+1000){y
a2 =. ((#y) | zero+2000){y
a3 =. ((#y) | zero+3000){y
echo (a1+a2+a3) NB., _, a1, a2, a3
)

print_ans 1 solve input
print_ans 10 solve 811589153 * input

exit 0
