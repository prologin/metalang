function idstring (s)
  return s
end

function printstring (s)
  io.write(string.format("%s\n", idstring(s)))
end

function print_toto (t)
  io.write(string.format("%s = %d\n", t.s, t.v))
end

local tab = {}
for i = 0, 1 do
    tab[i + 1] = idstring("chaine de test")
end
for j = 0, 1 do
    printstring(idstring(tab[j + 1]))
end
print_toto({s="one", v=1})
