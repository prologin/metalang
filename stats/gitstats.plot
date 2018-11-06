
set terminal pngcairo  transparent enhanced font "arial,10" fontscale 1.0 size 1200, 500
set output 'size.png'
set key outside bottom horizontal autotitles nobox
set title "taille du projet" 
set grid
set timefmt "%Y-%m-%d.%H:%M:%S"
set xdata time

set style line 1 lt 2 lw 2 pt 3 ps 0.5


plot \
     'countlines.dat' using 1:2 index 0 title "compiler" with lines lw 3,\
     'countlinesTest.dat' using 1:2 index 0 title "tests" with lines lw 3

set output 'langs.png'
set title "taille du projet" 

plot \
     'countlinesFUNML.dat' using 1:2 index 0 title "FUNML" with lines lw 2,\
     'countlinesML.dat' using 1:2 index 0 title "ML" with lines lw 2,\
     'countlinesC.dat' using 1:2 index 0 title "C" with lines lw 2,\
     'countlinesCC.dat' using 1:2 index 0 title "CC" with lines lw 2,\
     'countlinesPY.dat' using 1:2 index 0 title "PY" with lines lw 2,\
     'countlinesPAS.dat' using 1:2 index 0 title "PAS" with lines lw 2,\
     'countlinesGO.dat' using 1:2 index 0 title "GO" with lines lw 2,\
     'countlinesPHP.dat' using 1:2 index 0 title "PHP" with lines lw 2,\
     'countlinesJAVA.dat' using 1:2 index 0 title "JAVA" with lines lw 2,\
     'countlinesCL.dat' using 1:2 index 0 title "CL" with lines lw 2
