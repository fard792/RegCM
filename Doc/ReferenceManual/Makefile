

all: ReferenceMan.pdf

FIGURES = mm5_grid2.eps moloch_grid2.eps sigma_levels.eps moloch_levels.eps
TEXFILES = abstract.tex acronyms.tex description.tex \
					 intro.tex ack.tex
BIBFILES = references.bib 

ReferenceMan.pdf: ReferenceMan.tex $(TEXFILES) $(BIBFILES) $(FIGURES)
	pdflatex ReferenceMan
	bibtex ReferenceMan
	pdflatex ReferenceMan
	pdflatex ReferenceMan
	pdflatex ReferenceMan

clean:
	rm -f *.aux *.dvi *.pdf *.log *.toc *.lof *.lot *.bbl *.blg
