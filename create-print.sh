#!/bin/sh

# Synrc TeX Templates

create_tex()
{
	latex $2/$1.tex -output-directory=$2
}

create_tex index research/io
create_tex index .
create_tex labs .

