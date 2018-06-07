#
#  Makefile du projet metalang
#
#  Ce Makefile contient essentiellement les règles pour compiler le projet
#  metalang, ainsi que les règles pour le tester
#
#  usages :
#    make clean
#    make metalang
#    make testCompare
#        lance un teste approfondi
#    make testNotCompile
#        lance les tests qui ne doivent pas compiler
#    make doc
#        compile la documentation
#

reset	= \033[0m
red	= \033[0;31m
green	= \033[0;32m
yellow	= \033[0;33m

unit:
	ocamlbuild -use-ocamlfind src/unit.byte
	./unit.byte

lua	?=	lua
java	?=	java
python	?=	python3

TESTSNOTCOMPILEFILES := $(basename $(filter %.metalang, \
	$(shell ls tests/not_compile/)))

COMPILER_SOURCES:= $(shell find . \( -name "*.ml" -or -name "*.mll" -or -name "*.mly" \) -not -path "./out/*" -not -path "./_build/*")

TESTSFILES	:= $(filter %.metalang, $(shell ls tests/prog/))
TESTS		:= $(addprefix out/, $(basename $(TESTSFILES)))
TESTSDEPS	:= $(addsuffix .test, $(TESTS))

TMPFILES	:=\
	$(addsuffix .eval.out, $(TESTS)) \
	$(addsuffix .go, $(TESTS)) \
	$(addsuffix .m, $(TESTS)) \
	$(addsuffix .m.bin, $(TESTS)) \
	$(addsuffix .m.bin.out, $(TESTS)) \
	$(addsuffix .c, $(TESTS)) \
	$(addsuffix .c.bin, $(TESTS)) \
	$(addsuffix .c.bin.out, $(TESTS)) \
	$(addsuffix .hs, $(TESTS)) \
	$(addsuffix .hs.exe, $(TESTS)) \
	$(addsuffix .hs.exe.out, $(TESTS)) \
	$(addsuffix .ml, $(TESTS)) \
	$(addsuffix .ml.out, $(TESTS)) \
	$(addsuffix .ml.native, $(TESTS)) \
	$(addsuffix .ml.native.out, $(TESTS)) \
	$(addsuffix .ml.byte, $(TESTS)) \
	$(addsuffix .ml.byte.out, $(TESTS)) \
	$(addsuffix .pl, $(TESTS)) \
	$(addsuffix .pl.out, $(TESTS)) \
	$(addsuffix .rkt, $(TESTS)) \
	$(addsuffix .rkt.out, $(TESTS)) \
	$(addsuffix .fun.ml, $(TESTS)) \
	$(addsuffix .fun.ml.out, $(TESTS)) \
	$(addsuffix .fun.ml.native, $(TESTS)) \
	$(addsuffix .fun.ml.native.out, $(TESTS)) \
	$(addsuffix .fun.ml.byte, $(TESTS)) \
	$(addsuffix .fun.ml.byte.out, $(TESTS)) \
	$(addsuffix .java, $(TESTS)) \
	$(addsuffix .java.out, $(TESTS)) \
	$(addsuffix .js, $(TESTS)) \
	$(addsuffix .js.out, $(TESTS)) \
	$(addsuffix .py, $(TESTS)) \
	$(addsuffix .py.out, $(TESTS)) \
	$(addsuffix .php, $(TESTS)) \
	$(addsuffix .php.out, $(TESTS)) \
	$(addsuffix .exe, $(TESTS)) \
	$(addsuffix .exeVB, $(TESTS)) \
	$(addsuffix .exe.out, $(TESTS)) \
	$(addsuffix .exeVB.out, $(TESTS)) \
	$(addsuffix .class, $(TESTS)) \
	$(addsuffix .class.out, $(TESTS)) \
	$(addsuffix .cs, $(TESTS)) \
	$(addsuffix .vb, $(TESTS)) \
	$(addsuffix .cl, $(TESTS)) \
	$(addsuffix .cl.out, $(TESTS)) \
	$(addsuffix .fs, $(TESTS)) \
	$(addsuffix .fs.out, $(TESTS)) \
	$(addsuffix .st, $(TESTS)) \
	$(addsuffix .st.out, $(TESTS)) \
	$(addsuffix .rb, $(TESTS)) \
	$(addsuffix .rb.out, $(TESTS)) \
	$(addsuffix .cc, $(TESTS)) \
	$(addsuffix .cc.bin, $(TESTS)) \
	$(addsuffix .cc.bin.out, $(TESTS)) \
	$(addsuffix .cpp, $(TESTS)) \
	$(addsuffix .cpp.bin, $(TESTS)) \
	$(addsuffix .cpp.bin.out, $(TESTS)) \
	$(addsuffix .go, $(TESTS)) \
	$(addsuffix .go.out, $(TESTS)) \
	$(addsuffix .fsscript, $(TESTS)) \
	$(addsuffix .fsscript.exe, $(TESTS)) \
	$(addsuffix .fsscript.exe.out, $(TESTS)) \
	$(addsuffix .pas, $(TESTS)) \
	$(addsuffix .pas.bin, $(TESTS)) \
	$(addsuffix .pas.bin.out, $(TESTS)) \
	$(addsuffix .adb, $(TESTS)) \
	$(addsuffix .adb.bin, $(TESTS)) \
	$(addsuffix .adb.bin.out, $(TESTS)) \
	$(addsuffix .groovy, $(TESTS)) \
	$(addsuffix .groovy.out, $(TESTS)) \
	$(addsuffix .lua, $(TESTS)) \
	$(addsuffix .lua.out, $(TESTS)) \
	$(addsuffix .scala, $(TESTS)) \
	$(addsuffix .scala.out, $(TESTS)) \
	$(addsuffix .test, $(TESTS)) \
	$(addsuffix .not_compile, $(TESTSNOTCOMPILEFILES)) \
	$(addsuffix .outs, $(TESTS)) \
	$(addsuffix .metalang_parsed, $(TESTS))

.SECONDARY: $(TMPFILES)

# Compilation de metalang.
metalang : main.native
	cp _build/src/$^ $@

main.byte : $(COMPILER_SOURCES)
	@ocamlbuild -use-ocamlfind -tag debug src/main.byte

main.native : $(COMPILER_SOURCES)
	@ocamlbuild -use-ocamlfind src/main.native

# règles de génération des sources générées par les tests
define GENERATION
out/%.$1 : tests/prog/%.metalang tests/prog/%.in metalang Stdlib/stdlib.metalang
	@if [ -e "$$(basename $$<).compiler_input" ]; then \
	./metalang -quiet -o out -lang $1 $$< < "$$(basename $$<).compiler_input" || exit 1; \
	else \
	 ./metalang -quiet -o out -lang $1 $$< || exit 1; \
	fi
endef
$(foreach i, metalang fsscript groovy fs scala metalang st lua rkt php cc cpp c py rb hs ml pl fun.ml adb pas vb cs js java m cl go, $(eval $(call GENERATION,$(i))))

.PHONY: VERSIONS.rst
VERSIONS.rst:
	echo "compiler versions" > $@
	echo "==========" >> $@
	echo "" >> $@
	echo -n "* " >> $@; ocaml -version >> $@
	echo -n "* " >> $@; gcc --version | head -n 1 >> $@
	echo -n "* " >> $@; g++ --version | head -n 1 >> $@
	echo -n "* fpc " >> $@; fpc -i V | head -n 1 >> $@
	echo -n "* " >> $@; gnatmake --version | head -n 1 >> $@
	echo -n "* " >> $@; javac -version 2>> $@
	echo -n "* java " >> $@; java -version 2>&1 | head -n 1 >> $@
	echo -n "* " >> $@; mcs --version >> $@
	echo -n "* " >> $@; vbnc /help | head -n 1 >> $@
	echo -n "* " >> $@; fsharpc /help | head -n 1 >> $@
	echo -n "* " >> $@; ghc --version | head -n 1 >> $@
	echo -n "* " >> $@; mono --version | head -n 1 >> $@
	echo -n "* " >> $@; go version >> $@
	echo -n "* node " >> $@; node --version >> $@
	echo -n "* " >> $@; lua -v >> $@
	echo -n "* " >> $@; perl -v | grep -v "^$$" | head -n 1 >> $@
	echo -n "* " >> $@; scala -version 2>> $@
	echo -n "* " >> $@; php -v | head -n 1 >> $@
	echo -n "* " >> $@; gforth -v 2>> $@
	echo -n "* " >> $@; python --version 2>> $@
	echo -n "* " >> $@; sbcl --version >> $@
	echo -n "* gst " >> $@; gst --version | head -n 1 >> $@
	echo -n "* " >> $@; ruby --version >> $@
	echo -n "* " >> $@; racket --version >> $@
	echo -n "* " >> $@; groovy -version >> $@


# compilation dans les différents langages

out/%.m.bin : out/%.m
	@gcc $< -o $@ `gnustep-config --objc-flags` `gnustep-config --base-libs` -lm || exit 1
	@rm out/$(basename $*).m.d || exit 0

out/%.c.bin : out/%.c
	@gcc -std=c89 -Wall $< -o $@ -lm || exit 1

out/%.cc.bin : out/%.cc
	@g++ -Wall -std=c++11 $< -o $@ -lm || exit 1

out/%.cpp.bin : out/%.cpp
	@g++ -Wall -std=c++11 $< -o $@ -lm || exit 1

out/%.pas.bin : out/%.pas
	@fpc $< || exit 1
	@mv out/$(basename $*) $@
	@rm out/$(basename $*).o

out/%.adb.bin : out/%.adb
	@gnatmake $< -o $@ || exit 1
	@rm $(basename $*).o
	@rm $(basename $*).ali

out/%.class : out/%.java
	@javac $< || exit 1

out/%.exe : out/%.cs
	@mcs $< || exit 1

out/%.exeVB : out/%.vb
	@vbnc -removeintchecks $< -out:$@ || exit 1

out/%.fsscript.exe  : out/%.fsscript
	fsharpc $< -o $@ || exit 1

out/%.fun.ml.native : out/%.fun.ml
	@ocamlopt -w +A -g out/$(basename $*).fun.ml -o out/$(basename $*).fun.ml.native || exit 1
	@rm out/$(basename $*).fun.cmx || exit 0
	@rm out/$(basename $*).fun.cmi || exit 0
	@rm out/$(basename $*).fun.o || exit 0

out/%.ml.native : out/%.ml
	@ocamlopt -w +A -g out/$(basename $*).ml -o out/$(basename $*).ml.native || exit 1
	@rm out/$(basename $*).cmx || exit 0
	@rm out/$(basename $*).cmi || exit 0
	@rm out/$(basename $*).o || exit 0

out/%.hs.exe : out/%.hs
	@ghc -freduction-depth=1000 -rtsopts out/$(basename $*).hs -o out/$(basename $*).hs.exe || exit 1
	@rm out/$(basename $*).o
	@rm out/$(basename $*).hi

out/%.ml.byte : out/%.ml
	@ocamlc -w +A -g out/$(basename $*).ml -o -g out/$(basename $*).ml.byte || exit 1
	@rm out/$(basename $*).cmo || exit 0
	@rm out/$(basename $*).cmi || exit 0

out/%.bin.out : out/%.bin
	./$< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.eval.out : metalang
	@if [ -e "tests/prog/$(basename $*).compiler_input" ]; then \
		cat "tests/prog/$(basename $*).compiler_input" tests/prog/$(basename $*).in | ./metalang -eval tests/prog/$(basename $*).metalang  > $@ || exit 1; \
	else \
		./metalang -eval tests/prog/$(basename $*).metalang < tests/prog/$(basename $*).in > $@ || exit 1; \
	fi;

out/%.ml.native.out : out/%.ml.native
	./$< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.hs.exe.out : out/%.hs.exe
	./$< +RTS -K1G -RTS < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.fsscript.exe.out : out/%.fsscript.exe
	mono $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.go.out : out/%.go
	go run $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.ml.byte.out : out/%.ml.byte
	./$< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.class.out : out/%.class
	$(java) -classpath out $(basename $*) < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.js.out : out/%.js
	node $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.lua.out : out/%.lua
	$(lua) $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.pl.out : out/%.pl
	perl $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.scala.out : out/%.scala
	scala $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.ml.out : out/%.ml
	ocaml $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.php.out : out/%.php
	php $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.fs.out : out/%.fs
	gforth -m 2000M $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.py.out : out/%.py
	$(python) $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.cl.out : out/%.cl
	sbcl --script $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.st.out : out/%.st
	gst $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.rb.out : out/%.rb
	ruby $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.exe.out : out/%.exe
	mono $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.exeVB.out : out/%.exeVB
	mono $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.rkt.out : out/%.rkt
	racket $< < tests/prog/$(basename $*).in > $@ || exit 1;

out/%.groovy.out : out/%.groovy
	groovy $< < tests/prog/$(basename $*).in > $@ || exit 1;

# test global

out/%.test : out/%.fsscript.exe.out out/%.exeVB.out out/%.adb.bin.out out/%.rkt.out out/%.fun.ml.out out/%.pl.out out/%.rkt.out out/%.m.bin.out out/%.ml.out out/%.py.out out/%.php.out out/%.rb.out out/%.eval.out out/%.js.out out/%.cc.bin.out out/%.c.bin.out out/%.ml.native.out out/%.pas.bin.out out/%.class.out out/%.exe.out out/%.go.out out/%.cl.out out/%.fun.ml.native.out out/%.hs.exe.out out/%.lua.out out/%.scala.out out/%.st.out out/%.fs.out out/%.groovy.out
	@for i in $^; do \
	if diff "$$i" "$<" > /dev/null; then \
	echo "" > /dev/null; \
	else \
	echo "-------------------- $$i != $< "; \
	echo "FAIL $^" > $@; \
	echo -e "$(red)FAIL $^$(reset)"; \
	return 1; \
	fi; \
	done; \
	cp $< $@ ;\
	echo -e "$(green)OK $(basename $*)$(reset)";

.PHONY: testCompare
testCompare : $(addsuffix .test, $(TESTS))
	@echo -e "$(green)ALL TESTS OK$(reset)"

# test d'un langage et du caml

define TEST2
out/%.test_$1 : out/%.$1.out out/%.ml.out
	@for i in $$^; do \
	if diff "$$$$i" "$$<" > /dev/null; then \
	echo "" > /dev/null; \
	else \
	echo "-------------------- $$$$i != $$< "; \
	echo "FAIL $$^" > $$@; \
	echo -e "$(red)FAIL $$^$(reset)"; \
	return 1; \
	fi; \
	done; \
	cp $$< $$@ ; \
	echo -e "$(green)OK $$(basename $$*)$(reset)";

ifneq ($1, cpp.bin)
test_$1 : $(addsuffix .test_$1, $(TESTS))
endif

endef

$(foreach i, fsscript.exe groovy fs exeVB st adb.bin rkt fun.ml pl rkt m.bin ml py php rb eval js cc.bin cpp.bin c.bin ml.native pas.bin class exe go cl fun.ml.native hs.exe lua scala, $(eval $(call TEST2,$(i))))

IGNORE=out/aaa_05array out/bigints out/linkedList out/tictactoe
test_cpp.bin : $(addsuffix .test_cpp.bin, $(filter-out $(IGNORE),$(TESTS)))

reprint : $(addsuffix .metalang, $(TESTS))

# tests qui ne doivent pas compiler

%.not_compile : metalang
	@rm out/$(notdir $(basename $@)).ml -f || exit 0
	@./metalang tests/not_compile/$(notdir $(basename $@)).metalang -o out -lang ml || exit 0
	@if [ -e out/$(notdir $(basename $@)).ml ]; then exit 1; fi
	@echo -e "$(green)OK $(notdir $(basename $@))$(reset)"
	@touch $@

TESTSNOTCOMPILE	:= $(addprefix out/, \
	$(addsuffix .not_compile, $(TESTSNOTCOMPILEFILES)))
.PHONY: testNotCompile
testNotCompile : metalang out $(TESTSNOTCOMPILE)
	@echo -e "$(green)NOT COMPILE TESTS OK$(reset)"

# règles diverses

doc :
	@ocamlbuild -use-ocamlfind metalang.docdir/index.html

libmetalang.cma :
	@ocamlbuild -use-ocamlfind src/libmetalang.cma
	ocamlfind remove metalang
	ocamlfind install metalang META _build/src/*.cma _build/src/*.cmi

js/test.js : libmetalang.cma
	ocamlfind ocamlc \
		-package js_of_ocaml \
		-package js_of_ocaml.ppx \
		-package incr_dom \
		-package metalang -linkpkg -o js/test.byte js/test.ml
	js_of_ocaml +nat.js --disable genprim js/test.byte
	rm js/test.cmo js/test.cmi

js/meta.js : js/test.js
	#js_of_ocaml --runtime-only js/runtime.js
	cat js/header.js js/test.js > js/meta.js

.PHONY: clean
clean :
	@rm -rf out 2> /dev/null || true
	@mkdir out
	@ocamlbuild -clean
	@echo "OK"
