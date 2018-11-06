currentbranch(){
    git status -b -s | grep '#' | cut -d ' ' -f 2
}

origbranch=`currentbranch`
walk(){
    git log  --pretty=tformat:%H_%ci --topo-order --reverse | cut -d ' ' -f 1,2 --output-delimiter='.'
}

countml(){
    find . -name "*.ml" -not -path "./out/*"  -not -path "./_build/*" -exec cat {} \; | wc -l
}

count(){
    find ./out -name "$1" -exec cat {} \; | wc -c
}

counttestschars(){
    find ./tests/prog -name "*.metalang" -exec cat {} \; | tr -d ' \n' | wc -c
}
counttestslines(){
    find ./tests/prog -name "*.metalang" -exec cat {} \; | wc -l
}

echo "" > countlines.dat
echo "" > countlinesTest.dat
echo "" > countlinesC.dat
echo "" > countlinesCC.dat
echo "" > countlinesML.dat
echo "" > countlinesFUNML.dat
echo "" > countlinesPY.dat
echo "" > countlinesRB.dat
echo "" > countlinesJS.dat
echo "" > countlinesPAS.dat
echo "" > countlinesGO.dat
echo "" > countlinesPHP.dat
echo "" > countlinesJAVA.dat
echo "" > countlinesCL.dat
echo "" > countlinesCS.dat

makepoints(){
    statComp=`countml`
    echo "$1 $statComp" >> countlines.dat

    if [ -d ./tests/prog ]; then
        statMETALANG=`counttestschars`
        statMETALANGL=`counttestslines`
        statML=`count '*.ml'`
        statFUNML=`count '*.fun.ml'`
        statC=`count '*.c'`
        statCC=`count '*.cc'`
        statPY=`count '*.py'`
        statRB=`count '*.rb'`
        statJS=`count '*.js'`
        statPAS=`count '*.pas'`
        statGO=`count '*.go'`
        statPHP=`count '*.php'`
        statJAVA=`count '*.java'`
        statCS=`count '*.cs'`
        statCL=`count '*.cl'`
        if [ "$statMETALANGL" != "0" ]; then
            echo "$1 $statMETALANGL" >> countlinesTest.dat
        fi
        if [ "$statMETALANG" != "0" ]; then
            statML=$(( ( $statML - $statFUNML ) * 1000 / $statMETALANG ))
            statFUNML=$(( $statFUNML * 1000 / $statMETALANG ))
            statC=$(( $statC * 1000 / $statMETALANG ))
            statCC=$(( $statCC * 1000 / $statMETALANG ))
            statPY=$(( $statPY * 1000 / $statMETALANG ))
            statRB=$(( $statRB * 1000 / $statMETALANG ))
            statJS=$(( $statJS * 1000 / $statMETALANG ))
            statPAS=$(( $statPAS * 1000 / $statMETALANG ))
            statGO=$(( $statGO * 1000 / $statMETALANG ))
            statPHP=$(( $statPHP * 1000 / $statMETALANG ))
            statJAVA=$(( $statJAVA * 1000 / $statMETALANG ))
            statCS=$(( $statCS * 1000 / $statMETALANG ))
            statCL=$(( $statCL * 1000 / $statMETALANG ))
            if [ "$statFUNML" != "0" ]; then
	              echo "$1 $statFUNML" >> countlinesFUNML.dat
            fi
            if [ "$statML" != "0" ]; then
	              echo "$1 $statML" >> countlinesML.dat
            fi
            if [ "$statC" != "0" ]; then
                echo "$1 $statC" >> countlinesC.dat
            fi
            if [ "$statCC" != "0" ]; then
                echo "$1 $statCC" >> countlinesCC.dat
            fi
            if [ "$statPY" != "0" ]; then
                echo "$1 $statPY" >> countlinesPY.dat
            fi
            if [ "$statRB" != "0" ]; then
                echo "$1 $statRB" >> countlinesRB.dat
            fi
            if [ "$statJS" != "0" ]; then
                echo "$1 $statJS" >> countlinesJS.dat
            fi
            if [ "$statPAS" != "0" ]; then
                echo "$1 $statPAS" >> countlinesPAS.dat
            fi
            if [ "$statGO" != "0" ]; then
                echo "$1 $statGO" >> countlinesGO.dat
            fi
            if [ "$statPHP" != "0" ]; then
                echo "$1 $statPHP" >> countlinesPHP.dat
            fi
            if [ "$statJAVA" != "0" ]; then
                echo "$1 $statJAVA" >> countlinesJAVA.dat
            fi
            if [ "$statCS" != "0" ]; then
                echo "$1 $statCS" >> countlinesCS.dat
            fi
            if [ "$statCL" != "0" ]; then
                echo "$1 $statCL" >> countlinesCL.dat
            fi
        fi
    fi
}

for commit in `walk`; do
    commitdate=`echo $commit | cut -d '_' -f 2`
    commit=`echo $commit | cut -d '_' -f 1`
    echo "$commit $commitdate"
    git checkout "$commit" || exit 1
    makepoints "$commitdate" || exit 1
done

git checkout "$origbranch"
gnuplot gitstats.plot
