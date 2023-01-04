boxen =. ;:> <;._2 freads '21.txt'
NB.boxen =. ;:> <;._2 freads '21.test'

monkey =: 4 : 0
name=.>y
boxen=.x
index=.(>0{"1 boxen) i. name
num =. _ ". >1{index{boxen
if. num < _ do.
  x: num  NB. extended precision - we want to see all digits in the answer
else.
  m1 =. boxen monkey (>1{index{boxen),':'
  m2 =. boxen monkey (>3{index{boxen),':'
  operand =. ,>2{index{boxen
  if.     operand= '+' do. m1 + m2
  elseif. operand= '-' do. m1 - m2
  elseif. operand= '*' do. m1 * m2
  elseif. operand= '/' do. m1 % m2
  elseif. operand= '=' do. m1 = m2
  else. echo 'Unknown operand: "', (>2{index{boxen), '", "', name, '"'
  end.
end.
)

echo boxen monkey 'root:'

monkeytwo =: 4 : 0
name=.>y
boxen=.x
index=.(>0{"1 boxen) i. name
num =. _ ". >1{index{boxen
if. 'humn:' -: name do.
  'H'
elseif. num < _ do.
  x: num  NB. extended precision - we want to see all digits in the answer
else.
  m1 =. boxen monkeytwo (>1{index{boxen),':'
  m2 =. boxen monkeytwo (>3{index{boxen),':'
  nm1 =. _ ". ": m1
  nm2 =. _ ". ": m2
  operand =. ,>2{index{boxen
  if. 0 < (_=nm1)+(_=nm2) do.
	  '(',(":m1),')',(operand),'(',(":m2),')'
  elseif.     operand= '+' do. m1 + m2
  elseif. operand= '-' do. m1 - m2
  elseif. operand= '*' do. m1 * m2
  elseif. operand= '/' do. m1 % m2
  elseif. operand= '=' do. m1 = m2
  else. echo 'Unknown operand: "', (>2{index{boxen), '", "', name, '"'
  end.
end.
)

parttwo =. 3 : 0
boxen =. y
root =. (>0{"1 boxen) i. 'root:'
lh=. (>1{root{boxen),':'
rh=. (>3{root{boxen),':'
lhs =. ": boxen monkeytwo lh
rhs =. ": boxen monkeytwo rh

NB. expr = H | number | (expr) op (expr)
NB. We have exprL = exprR. Rearrange into H = expr
if. 'H' e. lhs do.
  hexpr =. lhs  NB. H-expression
  oexpr =. rhs  NB. other-expression
elseif. 'H' e. rhs do.
  hexpr =. rhs  NB. H-expression
  oexpr =. lhs  NB. other-expression
else.
  echo 'No ''H'''
  exit 0
end.

hexpr solve oexpr
)

solve =: 4 : 0
hexpr =. x
oexpr =. y
NB.while. -. hexpr -: 'H' do.
while. 1 < #hexpr do.
  NB. hexpr = string like '((2)%((H)-415))+((44)*2)'
  NB. index of 2nd zero in balanced count of parens
  s=. 1+ ((+/\ hexpr='(')-(+/\ hexpr=')')) i. 0
  ls=. s{.hexpr
  op=.s{hexpr
  rs=.(s+1)}.hexpr

  oexpr =. ": oexpr  NB. stringify
  if. 'H' e. ls do.
    NB. easy case
    hexpr =. }.}:ls  NB. strip off ( and )
    oexpr =. '(',oexpr,')',(('+-*/' i. op){'-+%*'),rs
  elseif. op e. '+*' do.  NB. commutative 
    hexpr =. }.}:rs  NB. strip off ( and )
    oexpr =. '(',oexpr,')',(('+*' i. op){'-%'),ls
  else.
    NB. (ls)-(rsH) = oexpr -> rsH = (ls)-(oexpr)
    hexpr =. }.}:rs
    oexpr =. ls,op,'(',oexpr,')'
  end.
  oexpr =. x: ". oexpr  NB. reduce
end.
oexpr
)

NB.echo 'H' solve '11'
NB.echo '(H)+(7)' solve '(80)-(3)'
echo parttwo boxen

exit 0
