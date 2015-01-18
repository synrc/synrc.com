#!/bin/sh

# Synrc TeX Templates

PWD=`pwd`
create_tex()
{
    cd $2
    latex $1.tex
    cd $PWD
}

#create_tex index research/io
#create_tex index .
#create_tex labs .
#create_tex github .
create_tex index apps/n2o/doc
create_tex elements apps/n2o/doc
create_tex actions apps/n2o/doc
create_tex api apps/n2o/doc
create_tex extending apps/n2o/doc
