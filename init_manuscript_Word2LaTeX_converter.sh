#!/bin/sh

###### RUN ON MAC OS HIGH SIERRA (local Terminal):

	## Prep:
	cp ./Word_text.txt ./Word_text.txt.tmp;
	mv ./Word_text.txt ..;

	## Introduction:

	### Fix ampersands, single and double quotes, italicize 'et al.', remove blank lines
	sed -i '' 's/\&/\\&/g; s/'\‘'/'\`'/g; s/'\’'/'\''/g; s/et al./\\emph\{et\ al\.\}/g' ./Word_text.txt.tmp
	#sed -i '' 's/^$\n//g' ./Word_text.txt.tmp
	perl -pe $'s/$/\ \\\\\\\\\n/g' ./Word_text.txt.tmp | perl -pe $'s/\n\ \\\\\n//g' > ./Word_text.txt
	sed -i '' 's/^$\n//g' ./Word_text.txt
#
	### Taxonomic names and Latin words/abbreviations
	sed -i '' 's/Populus\ tremuloides/\\emph\{Populus\ tremuloides\}/g' ./Word_text.txt
	sed -i '' 's/P\.\ tremuloides/\\emph\{P\.\ tremuloides\}/g' ./Word_text.txt
	sed -i '' 's/P\.\ balsamifera/\\emph\{P\.\ balsamifera\}/g' ./Word_text.txt
	sed -i '' 's/P\.\ trichocarpa/\\emph\{P\.\ trichocarpa\}/g' ./Word_text.txt
	sed -i '' 's/P\.\ grandidentata/\\emph\{P\.\ grandidentata\}/g' ./Word_text.txt
	sed -i '' 's/P\.\ tremula/\\emph\{P\.\ tremula\}/g' ./Word_text.txt
	sed -i '' 's/smithii/\\emph\{smithii}/g' ./Word_text.txt
	sed -i '' 's/\ Populus\ /\ \\emph\{Populus\}\ /g' ./Word_text.txt
	sed -i '' 's/\ Populus\,/\ \\emph\{Populus\}\,/g' ./Word_text.txt
	sed -i '' 's/Populus\,/\\emph\{Populus\}\,/g' ./Word_text.txt
	sed -i '' 's/cf\./\\emph\{cf\.\}/g' ./Word_text.txt
	sed -i '' 's/a\ priori/\\emph\{a\ priori\}/g' ./Word_text.txt
#
	### Special characters
	### - alphanumeric
	sed -i '' 's/'ö'/\\'\"'\{o\}/g' ./Word_text.txt
	sed -i '' 's/'é'/\\'\''\{e\}/g' ./Word_text.txt
	sed -i '' 's/'é'/\\'\''\{e\}/g' ./Word_text.txt
#
	### - symbols/strings
	sed -i '' 's/\–/\\textendash\ /g' ./Word_text.txt
	sed -i '' 's/\~/\$\\sim\$/g' ./Word_text.txt
	sed -i '' 's/\×/\$\\times\$/g' ./Word_text.txt
	sed -i '' 's/\>/\\textgreater/g' ./Word_text.txt
	sed -i '' 's/\</\\textless/g' ./Word_text.txt
	sed -i '' 's/n\ \=/\\emph\{n\}\ \=/g' ./Word_text.txt
#
	sed -i '' 's/^\t//g' ./Word_text.txt
	sed -i '' 's/^//g' ./Word_text.txt



	## Materials & Methods:

	sed -i '' 's/a\ priori/\\emph\{a\ priori\}/g' ./Word_text.txt
#
	sed -i '' 's/H1/H\\textsubscript\{1\}/g' ./Word_text.txt
	sed -i '' 's/H2/H\\textsubscript\{2\}/g' ./Word_text.txt
	sed -i '' 's/H3/H\\textsubscript\{3\}/g' ./Word_text.txt



exit 0

