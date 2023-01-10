inp =: ];._1 |. freads '25.txt'  NB. Reverse it, so that LSB is first and padding fills the MSBs (with ' ')
unsnafu =: 3 : '+/ ((''=-012 '' i.y) { _2 _1 0 1 2 0) * (x: 5)^i.#y'
total =. +/ unsnafu"1 inp

snafu =: 3 : 0
 arr =. ''
 while. y do.
   qr =. 0 5 #:y
   y =. 0{qr
   r =. 1{qr
   if. r>2 do.
     r =. r-5
     y =. y+1
   end.
   arr =. r, arr  NB. MSB first
 end.
 (arr+2) { '=-012'
)

echo snafu total
exit 0
