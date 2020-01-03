.SUFFIXES: .out .java .lua

GRMTOOLSV=grmtools-0.5.1
GRAMMARSV=35c7848215e5565ddc3a2ea71a60fa26107a6a2e

EXAMPLES=java_ex1.out java_ex2.out java_ex3.out java_ex4.out java_ex5.out java_ex6.out \
		 lua_ex1.out lua_ex2.out lua_ex3.out lua_ex4.out lua_ex5.out php_ex1.out php_ex2.out \
		 php_ex3.out

NP=grmtools/target/release/nimbleparse

all: ${EXAMPLES}

clean:
	rm -rf grammars grmtools ${EXAMPLES}

%.out: %.java ${NP} grammars
	${NP} grammars/java7/java.l grammars/java7/java.y $< | sed -n '/Parsing error/,$$p' > $@

%.out: %.lua ${NP} grammars
	${NP} grammars/lua5_3/lua5_3.l grammars/lua5_3/lua5_3.y $< | sed -n '/Parsing error/,$$p' > $@

%.out: %.php ${NP} grammars
	${NP} grammars/php7/php.l grammars/php7/php.y $< | sed -n '/Parsing error/,$$p' > $@

${NP}: grmtools
	cd grmtools && cargo build --release

grammars:
	git clone https://github.com/softdevteam/grammars/
	cd grammars && git checkout ${GRAMMARSV}

grmtools:
	git clone https://github.com/softdevteam/grmtools
	cd grmtools && git checkout ${GRMTOOLSV}
