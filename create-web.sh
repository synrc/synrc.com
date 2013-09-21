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
create_page client/sync/windows/index
create_page client/chat/haiku/index
create_page beos/beos_collection
create_page news/erlang2013kiev
create_page news/kievfprog2013
create_page news/hotcode2013
create_page news/index
create_page research/io/doc/overview
create_page research/io/doc/object
create_page research/io/doc/primitives

# Synrc HeVeA Templates for both HTML rendering and TeX outputs

create_hevea()
{
        echo `pwd`
	hevea $1.tex -o $1.htm
}

create_hevea "index"
create_hevea "feedback"
create_hevea "research"
create_hevea "labs"
create_hevea "github"
cd research/io
create_hevea "index"
cd -
cd framework/web
create_hevea "index"
create_hevea "setup"
create_hevea "architecture"
create_hevea "elements"
create_hevea "actions"
create_hevea "api"
create_hevea "macros"
cd -
#create_hevea "framework/snmp/index"
#create_hevea "beos/beos"
