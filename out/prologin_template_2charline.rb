require "scanf.rb"
def programme_candidat( tableau1, taille1, tableau2, taille2 )
    out_ = 0
    for i in (0 ..  taille1 - 1) do
      out_ += tableau1[i].ord * i
      printf "%c", tableau1[i]
    end
    print "--\n";
    for j in (0 ..  taille2 - 1) do
      out_ += tableau2[j].ord * j * 100
      printf "%c", tableau2[j]
    end
    print "--\n";
    return (out_);
end

b = 0
b=scanf("%d")[0];
scanf("%*\n");
taille1 = b
d = [];
for e in (0 ..  taille1 - 1) do
  f = "_"
  f=scanf("%c")[0];
  d[e] = f;
end
scanf("%*\n");
tableau1 = d
h = 0
h=scanf("%d")[0];
scanf("%*\n");
taille2 = h
l = [];
for m in (0 ..  taille2 - 1) do
  o = "_"
  o=scanf("%c")[0];
  l[m] = o;
end
scanf("%*\n");
tableau2 = l
printf "%d\n", programme_candidat(tableau1, taille1, tableau2, taille2)

