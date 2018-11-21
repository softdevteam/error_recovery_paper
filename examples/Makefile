.SUFFIXES: .out .java .lua

GRMTOOLSV=8aad0787
GRAMMARSV=e236ea07

EXAMPLES=java_ex1.out java_ex2.out java_ex3.out java_ex4.out java_ex5.out java_ex6.out \
		 lua_ex1.out lua_ex2.out lua_ex3.out lua_ex4.out lua_ex5.out php_ex1.out php_ex2.out \
		 php_ex3.out

NP=grmtools/target/release/nimbleparse

all: ${EXAMPLES}

clean:
	rm -rf grammars grmtools ${EXAMPLES}

%.out: %.java ${NP} grammars
	${NP} grammars/java7/java.l grammars/java7/java.y $< | sed -n '/Error/,$$p' > $@

%.out: %.lua ${NP} grammars
	${NP} -r cpctplus grammars/lua5_3/lua5_3.l grammars/lua5_3/lua5_3.y $< | sed -n '/Error/,$$p' > $@

%.out: %.php ${NP} grammars
	${NP} -r cpctplus grammars/php7/php.l grammars/php7/php.y $< | sed -n '/Error/,$$p' > $@

${NP}: grmtools
	cd grmtools && cargo build --release

grammars:
	git clone https://github.com/softdevteam/grammars/
	cd grammars && git checkout ${GRAMMARSV}

grmtools:
	git clone https://github.com/softdevteam/grmtools
	cd grmtools && git checkout ${GRMTOOLSV}
