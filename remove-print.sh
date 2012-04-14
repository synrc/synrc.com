#!/bin/sh

remove_print()
{
	rm $1.aux
	rm $1.log
	rm $1.haux
}

remove_print research
remove_print index
remove_print labs
remove_print io/index
