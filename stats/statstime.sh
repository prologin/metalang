
militime(){
    date +"%s"
}

diff(){
    echo "$(( $2 - $1 ))"
}

make clean
make metalang
make allsources
start=$(militime)
make compileC
afterC=$(militime)
make compileCC
afterCC=$(militime)
make compileML
afterML=$(militime)
make compilePAS
afterPAS=$(militime)
make compileJAVA
afterJAVA=$(militime)
make compileCS
afterCS=$(militime)

ctime=$(diff $start $afterC)
cctime=$(diff $afterC $afterCC)
mltime=$(diff $afterCC $afterML)
pastime=$(diff $afterML $afterPAS)
javatime=$(diff $afterPAS $afterJAVA)
cstime=$(diff $afterJAVA $afterCS)

echo "c $ctime
cc $cctime
ml $mltime
pas $pastime
java $javatime
cs $cstime
" > compilestats.dat

 echo "
set terminal pngcairo transparent size 600, 600
set output 'compilestats.png'
set title \"temps de compilation\"
set style fill solid 0.25 noborder
set boxwidth 0.75
set yrange [0:*]
plot 'compilestats.dat' using 2:xtic(1) notitle with boxes,\
'' using 0:2:2 with labels center offset 0,-1 rotate by 90 notitle
" > compilestats.plot

gnuplot compilestats.plot

start=$(militime)
make execC
afterC=$(militime)
make execCC
afterCC=$(militime)
make execML
afterML=$(militime)
make execPAS
afterPAS=$(militime)
make execJAVA
afterJAVA=$(militime)
make execCS
afterCS=$(militime)
# TODO py, rb, php, objC, cl, go

ctime=$(diff $start $afterC)
cctime=$(diff $afterC $afterCC)
mltime=$(diff $afterCC $afterML)
pastime=$(diff $afterML $afterPAS)
javatime=$(diff $afterPAS $afterJAVA)
cstime=$(diff $afterJAVA $afterCS)

echo "c $ctime
cc $cctime
ml $mltime
pas $pastime
java $javatime
cs $cstime
" > execstats.dat

 echo "
set terminal pngcairo transparent size 600, 600
set output 'execstats.png'
set title \"temps d'execution\"
set style fill solid 0.25 noborder
set boxwidth 0.75
set yrange [0:*]
plot 'execstats.dat' using 2:xtic(1) notitle with boxes,\
'' using 0:2:2 with labels center offset 0,-1 rotate by 90 notitle
" > execstats.plot

gnuplot execstats.plot
