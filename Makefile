.SUFFIXES: .ltx .ps .dia .pdf .svg

.dia.pdf:
	dia -e eps-builtin -n -e ${@:.pdf=.eps} $<
	ps2pdf -dEPSCrop ${@:.pdf=.eps} $@

.svg.pdf:
	inkscape --export-filename=$@ $<

LATEX_FILES = error_recovery.ltx experimentstats.tex table.tex

DIAGRAMS = graph.pdf cpctplus.pdf examplegrammar.pdf

EXTRA_DISTRIB_FILES = error_recovery.pdf Makefile

all: error_recovery.pdf

bib.bib: softdevbib/softdev.bib
	softdevbib/bin/prebib softdevbib/softdev.bib > bib.bib

softdevbib-update: softdevbib
	cd softdevbib && git pull

softdevbib/softdev.bib: softdevbib

softdevbib:
	git clone https://github.com/softdevteam/softdevbib.git


# Package up the paper for arxiv.org.
ARXIV_FILES=graph.pdf \
		cpctplus.pdf \
		examplegrammar.pdf \
		cpctplus_histogram.pdf \
		cpctplus_cpctplusrev_error_locs_histogram_zoomed.pdf \
		cpctpluslonger_histogram.pdf \
		cpctplus_cpctplusrev_error_locs_histogram_full.pdf \
		orcid.pdf \
		cc-by.pdf \
		lipics-logo-bw.pdf \
		softdev.sty \
		bib.bib \
		error_recovery.bbl \
		experimentstats.tex \
		table.tex \
		examples/java_ex1.java \
		examples/java_ex1.out \
		examples/java_ex2.java \
		examples/java_ex2.out \
		examples/java_ex3.java \
		examples/java_ex3.out \
		examples/java_ex4.java \
		examples/java_ex4.out \
		examples/java_ex5.java \
		examples/java_ex5.out \
		examples/java_ex6.java \
		examples/java_ex6.out \
		examples/lua_ex1.lua \
		examples/lua_ex1.out \
		examples/lua_ex2.lua \
		examples/lua_ex2.out \
		examples/lua_ex3.lua \
		examples/lua_ex3.out \
		examples/lua_ex4.lua \
		examples/lua_ex4.out \
		examples/lua_ex5.lua \
		examples/lua_ex5.out \
		examples/php_ex1.php \
		examples/php_ex1.out \
		examples/php_ex2.php \
		examples/php_ex2.out \
		examples/php_ex3.php \
		examples/php_ex3.out

ARXIV_BASE=arxiv
${ARXIV_BASE}: error_recovery.pdf
	mkdir $@
	rsync -Rav ${ARXIV_FILES} $@
	cp error_recovery.ltx $@/error_recovery.tex
	cp lipics-v2019.cls $@/lipics-v2019.cls
	zip -r $@.zip ${ARXIV_BASE}

clean-arxiv:
	rm -rf arxiv
	rm -rf arxiv.zip

clean: clean-arxiv
	rm -rf ${DIAGRAMS} ${DIAGRAMS:S/.pdf/.eps/}
	rm -rf error_recovery.aux error_recovery.bbl error_recovery.blg \
		error_recovery.dvi error_recovery.log error_recovery.ps error_recovery.pdf \
		error_recovery.toc error_recovery.out error_recovery.snm error_recovery.nav \
		error_recovery.vrb texput.log bib.bib
	cd examples && ${MAKE} clean

error_recovery.pdf: ${LATEX_FILES} ${DIAGRAMS} bib.bib
	cd examples && ${MAKE} ${MFLAGS}
	pdflatex error_recovery.ltx
	bibtex error_recovery
	pdflatex error_recovery.ltx
	pdflatex error_recovery.ltx
