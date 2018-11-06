st(){
    a=`pwd`
    cd "$2"
    cat `ls | grep "^\\([^.]*\\).${1}\$" ` | tr -d ' \n\t' | wc -c
    cd "$a"
}

metalang=$(st "metalang" "tests/prog")
c=$(st "c" "out")
cc=$(st  "cc" "out")
ml=$(st  "ml" "out")
funml=$(st  "fun.ml" "out")
rkt=$(st  "rkt" "out")
php=$(st  "php" "out")
pas=$(st  "pas" "out")
js=$(st  "js" "out")
go=$(st  "go" "out")
cl=$(st  "cl" "out")
py=$(st  "py" "out")
rb=$(st  "rb" "out")
cs=$(st  "cs" "out")
m=$(st  "m" "out")
pl=$(st  "pl" "out")
java=$(st  "java" "out")
ada=$(st  "adb" "out")
vb=$(st  "vb" "out")
hs=$(st  "hs" "out")
lua=$(st  "lua" "out")
scala=$(st  "scala" "out")
smalltalk=$(st  "st" "out")
forth=$(st  "fs" "out")
groovy=$(st  "groovy" "out")
fsharp=$(st  "fsscript" "out")

c=$(( $c * 1000 / $metalang))
cc=$(( $cc * 1000 / $metalang))
ml=$(( $ml * 1000 / $metalang))
funml=$(( $funml * 1000 / $metalang))
rkt=$(( $rkt * 1000 / $metalang))
php=$(( $php * 1000 / $metalang))
pas=$(( $pas * 1000 / $metalang))
js=$(( $js * 1000 / $metalang))
go=$(( $go * 1000 / $metalang))
cl=$(( $cl * 1000 / $metalang))
py=$(( $py * 1000 / $metalang))
rb=$(( $rb * 1000 / $metalang))
cs=$(( $cs * 1000 / $metalang))
m=$(( $m * 1000 / $metalang))
pl=$(( $pl * 1000 / $metalang))
vb=$(( $vb * 1000 / $metalang))
java=$(( $java * 1000 / $metalang))
ada=$(( $ada * 1000 / $metalang))
hs=$(( $hs * 1000 / $metalang))
lua=$(( $lua * 1000 / $metalang))
scala=$(( $scala * 1000 / $metalang))
smalltalk=$(( $smalltalk * 1000 / $metalang))
forth=$(( $forth * 1000 / $metalang))
groovy=$(( $groovy * 1000 / $metalang))
fsharp=$(( $fsharp * 1000 / $metalang))

file="stats_repartition.dat"

makearcstring(){
local arc=`echo "$1" | rev`
local exarc=`echo "$2" | rev`

local arcint=$(echo ${arc:2} | rev )
local arcfloat=$(echo ${arc:0:2} | rev )
local exarcint=$(echo ${exarc:2} | rev )
local exarcfloat=$(echo ${exarc:0:2} | rev )
echo "[$exarcint.$exarcfloat:$arcint.$arcfloat]"
}

swap(){
    local line
    local i
    local word
    while read line; do
	for i in $(echo "$line" | rev); do
	    word=$(echo "$i" | rev)
	    echo -n "$word "
	done
	echo
    done
}

(echo "c $c
c++ $cc
camlImperatif $ml
camlFonctionnel $funml
racket $rkt
php $php
pascal $pas
javascript $js
go $go
commonLisp $cl
objective-C $m
python $py
ruby $rb
c# $cs
perl $pl
ada $ada
vb.net $vb
haskell $hs
lua $lua
smalltalk $smalltalk
scala $scala
forth $forth
java $java
groovy $groovy
fsharp $fsharp
" | swap | sort -n | swap ) > "$file"

filestatsplot(){
    IFS='
'
    sum=0
    for i in `cat "$file"`; do
	lng=`echo "$i" | cut -d ' ' -f 1`
	size=`echo "$i" | cut -d ' ' -f 2`
	sum=$(( $sum + $size ))
    done
    position="center screen 0.5, 0.5"
    echo "
set terminal pngcairo transparent size 800, 600
set output 'repartition.png'
set title \"repartition des langages\"
set style fill solid 0.25 noborder
set boxwidth 0.75
set grid y
set yrange [0:*]
set xtic rotate by -65 scale 0 font \",8\""
    exarc=0
    n=10
# lignes commentées pour la création d'un camembert
    for i in `cat "$file"`; do
	n=$(($n + 1))
	lng=`echo "$i" | cut -d ' ' -f 1`
	size=`echo "$i" | cut -d ' ' -f 2`
	echo "# $lng : $size ($sum)"
	arc=$(( $exarc + 36000 * $size / $sum))
	arcstr=$(makearcstring $arc $exarc)
	echo "
#set object $n circle $position, 0 size screen 0.4 arc $arcstr
#set object $n front lw 1.0 fillstyle solid 1.00 border lt -1
"
	exarc=$arc
    done
echo "
set size ratio -1 1,1
plot 'stats_repartition.dat' using 2:xtic(1) notitle with boxes,\
'' using 0:(\$2/2):2 with labels center offset 0,0  rotate by 90 notitle
"
}
filestatsplot > stats.plot

gnuplot stats.plot
