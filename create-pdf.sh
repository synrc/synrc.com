#!/bin/sh

# Synrc Site Templates when designing HTML pages

create_pdf()
{
    cd apps/`basename $1`/doc
    pdflatex book.tex
    cd -
}

#create_pdf ~/depot/synrc/mad
#create_pdf ~/depot/spawnproc/upl
#create_pdf ~/depot/spawnproc/forms
#create_pdf ~/depot/spawnproc/bpe

create_pdf ~/depot/synrc/n2o
