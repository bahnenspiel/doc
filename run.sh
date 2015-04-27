#!/bin/sh

pdflatex main.tex
bibtex main > bibtex_log.txt
pdflatex main.tex
pdflatex main.tex
pdflatex main.tex

mv main.pdf Projektdokumentation.pdf

./clear.sh
