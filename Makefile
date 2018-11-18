.SUFFIXES: .ltx .ps .dia .pdf .svg

.dia.pdf:
	dia -e eps-builtin -n -e ${@:.pdf=.eps} $<
	ps2pdf -dEPSCrop ${@:.pdf=.eps} $@

.svg.pdf:
	inkscape --export-pdf=$@ $<

LATEX_FILES = error_recovery.ltx experimentstats.tex table.tex

DIAGRAMS = graph.pdf cpctplus.pdf

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
# Note that acmart.cls is included in tex live 2016, but it is too old.
ARXIV_FILES=graph.pdf \
		cpctplus.pdf \
		mf_histogram.pdf \
		mf_mfrev_error_locs_histogram.pdf \
		softdev.sty \
		bib.bib \
		error_recovery.bbl \
		experimentstats.tex \
		table.tex

ARXIV_BASE=arxiv
${ARXIV_BASE}: error_recovery.pdf acmart
	mkdir $@
	rsync -Rav ${ARXIV_FILES} $@
	cp error_recovery.ltx $@/error_recovery.tex
	cp acmart.cls $@
	cp acmart/acmart.dtx $@
	cp acmart/acmart.ins $@
	zip -r $@.zip ${ARXIV_BASE}

ACMART_VERSION=904956ed0f4545da4fbb7f2401318917a348ba75
acmart:
	git clone https://github.com/borisveytsman/acmart
	cd acmart && git checkout ${ACMART_VERSION}

clean-arxiv:
	rm -rf arxiv
	rm -rf arxiv.zip
	rm -rf acmart

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
