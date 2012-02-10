README
======
Synrc Site is been built from TeX using HeVeA.

INSTALL
=======
First you need to install LaTeX and HeVeA for producing PDF and HTML.
Then you need to checkout Synrc Site and all Synrc Repositories:

        $ git clone git://github.com/5HT/synrc.com.git
        $ cd synrc.com
        $ mkdir client
        $ mkdir client/sync
        $ mkdir client/sync/windows
        $ mkdir client/chat
        $ mkdir client/chat/symbian
        $ mkdir client/chat/meego
        $ mkdir client/chat/haiku
        $ mkdir client/chat/javascript
        $ git clone git://github.com/synrc/symbian-chat-client.git client/chat/symbian
        $ git clone git://github.com/synrc/windows-sync-client.git client/sync/windows
        $ git clone git://github.com/synrc/meego-chat-client.git client/chat/meego
        $ git clone git://github.com/synrc/javascript-chat-client.git client/chat/javascript
        $ mkdir server
        $ git clone git://github.com/synrc/chat-server.git server/chat
        $ git clone git://github.com/synrc/sync-server.git server/sync
        $ git clone git://github.com/synrc/directory-server.git server/directory
        $ mkdir research 
        $ git clone git://github.com/synrc/research-ml.git research/ml
        $ git clone git://github.com/synrc/research-io.git research/io
        $ git clone git://github.com/synrc/research-pl.git research/pl

USAGE
=====
Create HTML site:

        $ sh create-web.sh

Create LaTeX site:

        $ sh create-print.sh
