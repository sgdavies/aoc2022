boxen =: ;:> <;._2 freads '21.txt'

monkey =: 3 : 0
name=.>y
index=.(>0{"1 boxen) i. name
num =. _ ". >1{index{boxen
if. num < _ do.
  x: num
else.
  m1 =. monkey (>1{index{boxen),':'
  m2 =. monkey (>3{index{boxen),':'
  operand =. ,>2{index{boxen
  if.     operand= '+' do. m1 + m2
  elseif. operand= '-' do. m1 - m2
  elseif. operand= '*' do. m1 * m2
  elseif. operand= '/' do. m1 % m2
  else. echo 'Unknown operand: "', (>2{index{boxen), '", "', name, '"'
  end.
end.
)

echo monkey 'root:'

exit 0
