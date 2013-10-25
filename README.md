Synrc Research Center Web Site
==============================

Synrc Site is been built from TeX using HeVeA.

Install
=======

First you need to install LaTeX and HeVeA for producing PDF and HTML.
Then you need to checkout Synrc Site and all Synrc Repositories:

    $ sudo apt-get install texlive-full
    $ sudo apt-get install hevea
    $ git clone git@github.com:synrc/synrc.com
    $ (cd framework/web; git clone git@github.com:5HT/n2o)

Usage
=====

Create HTML site:

        $ sh create-web.sh
