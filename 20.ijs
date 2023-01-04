start =. 1 2 _3 3 _2 0 4
start =. ". ;._2 freads '20.txt'

solve =. 3 : 0
arr =. i.#y

for_x. i.#y do.
    pos =. arr i. x
    val =. x{y
    arr =. pos |. arr
    if. val < 0 do.
      s =. (_1+#arr) | -val
      arr =. x, (-s) |. }.arr
    else.
      s =. (_1+#arr) | val
      arr =. x, s |. }.arr
    end.
    NB.echo  x, val, pos, _, arr, _, arr{y
end.
arr { y
)

ans =. solve start
zero =. ans i. 0
a1 =. ((#ans) | zero+1000){ans
a2 =. ((#ans) | zero+2000){ans
a3 =. ((#ans) | zero+3000){ans
echo (a1+a2+a3) NB., _, a1, a2, a3

exit 0
