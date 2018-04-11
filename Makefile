.SUFFIXES: .ltx .ps .dia .pdf .svg

.dia.pdf:
	dia -e eps-builtin -n -e ${@:.pdf=.eps} $<
	ps2pdf -dEPSCrop ${@:.pdf=.eps} $@

.svg.pdf:
	inkscape --export-pdf=$@ $<

LATEX_FILES = error_recovery.ltx

DIAGRAMS = graph.pdf

EXTRA_DISTRIB_FILES = error_recovery.pdf Makefile

all: error_recovery.pdf

bib.bib: softdevbib/softdev.bib
	softdevbib/bin/prebib softdevbib/softdev.bib > bib.bib

softdevbib-update: softdevbib
	cd softdevbib && git pull

softdevbib/softdev.bib: softdevbib

softdevbib:
	git clone https://github.com/softdevteam/softdevbib.git

clean:
	rm -rf ${DIAGRAMS} ${DIAGRAMS:S/.pdf/.eps/}
	rm -rf error_recovery.aux error_recovery.bbl error_recovery.blg \
		error_recovery.dvi error_recovery.log error_recovery.ps error_recovery.pdf \
		error_recovery.toc error_recovery.out error_recovery.snm error_recovery.nav \
		error_recovery.vrb texput.log bib.bib

error_recovery.pdf: ${LATEX_FILES} ${DIAGRAMS} bib.bib
	pdflatex error_recovery.ltx
	bibtex error_recovery
	pdflatex error_recovery.ltx
	pdflatex error_recovery.ltx

