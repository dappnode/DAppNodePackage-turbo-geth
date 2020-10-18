#!/bin/sh
tg --lmdb.mapSize=$LMDB_MAPSIZE --metrics --metrics.addr="0.0.0.0" --metrics.port="6060" --private.api.addr="0.0.0.0:9090" --pprof --pprof.addr="0.0.0.0" --pprof.port="6061" &
restapi --http.addr="0.0.0.0:8080" --private.api.addr="localhost:9090" &
exec rpcdaemon --private.api.addr="localhost:9090" --http.addr="0.0.0.0" --http.vhosts="*" --http.corsdomain="*" --http.api="eth,debug,net"