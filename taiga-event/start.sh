#!/bin/sh

chown -R taiga /home/taiga/

/usr/local/bin/circusd /home/taiga/taiga-events/circus.ini
