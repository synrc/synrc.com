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

#create_page news/2013/courses
#create_page news/2013/hotcode
#create_page news/2013/fprog-1
#create_page news/2013/itjam
#create_page news/2013/mirin
#create_page news/2013/fprog-2
#create_page news/2014/brug
#create_page news/2014/california
#create_page news/2014/odessa
#create_page news/2014/courses
#create_page news/2014/mostfunctional
#create_page news/index

# Synrc HeVeA Templates for both HTML rendering and TeX outputs

create_hevea()
{
    echo `pwd`
	hevea $1.tex -o $1.htm
}

create_hevea "5HT"
create_hevea "index"
create_hevea "feedback"
create_hevea "research"
create_hevea "labs"
create_hevea "apps"
cd apps/n2o/doc/web
create_hevea "index"
create_hevea "setup"
create_hevea "processes"
create_hevea "endpoints"
create_hevea "protocols"
create_hevea "handlers"
create_hevea "macros"
create_hevea "api"
create_hevea "elements"
create_hevea "actions"
create_hevea "packages"
create_hevea "persistence"
create_hevea "utf8"
cd -
cd apps/mad/doc/web
create_hevea "index"
create_hevea "setup"
create_hevea "commands"
create_hevea "bundles"
create_hevea "config"
create_hevea "deps"
create_hevea "ports"
create_hevea "scripts"
cd -
cd apps/upl/doc/web
create_hevea "index"
