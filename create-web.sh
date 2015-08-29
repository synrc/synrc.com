#!/bin/sh

# Synrc Site Templates when designing HTML pages

create_page()
{
	cat templates/begin.htx > $1.htm
	cat templates/head-hevea.htx >> $1.htm
	echo "</p>" >> $1.htm
	cat templates/$1.htx >> $1.htm
	echo "<p>" >> $1.htm
	cat templates/foot.htx >> $1.htm
	echo "</p>" >> $1.htm
	cat templates/end.htx >> $1.htm
	echo "generated $1.htm"
}

create_page privacy
create_page brandbook
create_page news/2013/courses
create_page news/2013/hotcode
create_page news/2013/fprog-1
create_page news/2013/itjam
create_page news/2013/mirin
create_page news/2013/fprog-2
create_page news/2014/brug
create_page news/2014/california
create_page news/2014/odessa
create_page news/2014/courses
create_page news/2014/mostfunctional
create_page news/index

# Synrc HeVeA Templates for both HTML rendering and TeX outputs

create_hevea()
{
    echo "Creating hevea page $2"
    echo `pwd`
	hevea $1.tex -o $1.htm
}

create_article()
{
    echo "Creating article $1.tex from book $2"
    ln -fs $2/doc/$1.tex ../$1.tex
    ln -fs $2/doc/web/$1.tex $1.tex
	hevea $1.tex -o $1.htm
}

create_book()
{
    echo "Creating book $1"
    cd apps/`basename $1`/doc/web
    rm *.htm
    ln -fs ../../../../templates templates
    ln -fs $1/doc/book.tex  ../book.tex
    ln -fs $1/doc/hevea.sty ../hevea.sty
    for article in $1/doc/*.tex; do create_article `basename ${article%%.*}` $1; done
    cp index.htm ../../index.htm
    cd -
}

create_hevea "5HT"
create_hevea "index"
create_hevea "feedback"
create_hevea "research"
create_hevea "apps"

create_book ~/depot/synrc/mad
create_book ~/depot/synrc/n2o
create_book ~/depot/spawnproc/upl
create_book ~/depot/spawnproc/forms
create_book ~/depot/spawnproc/bpe

cp apps.htm apps/index.htm
