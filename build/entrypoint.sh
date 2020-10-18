#!/bin/sh
tg --lmdb.mapSize=$LMDB_MAPSIZE --private.api.addr=0.0.0.0:9090 &
exec rpcdaemon --chaindata /root/.local/share/turbogeth/tg/chaindata --http.api=eth,debug,net --http.addr=0.0.0.0 --http.vhosts='*' --ws  