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
create_tex index framework/web
create_tex elements framework/web
create_tex actions framework/web
create_tex api framework/web
create_tex extending framework/web
