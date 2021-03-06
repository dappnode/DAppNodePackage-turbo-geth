
FROM golang:1.15-alpine3.12 as builder

ARG UPSTREAM_VERSION 
RUN apk --no-cache add make gcc g++ linux-headers git bash ca-certificates libgcc libstdc++

WORKDIR /app

RUN git clone -b ${UPSTREAM_VERSION} --recurse-submodules -j8 https://github.com/ledgerwatch/turbo-geth.git /app
RUN go mod download
# https://github.com/valyala/gozstd/issues/20#issuecomment-557499034
RUN GOZSTD_VER=$(cat go.mod | fgrep github.com/valyala/gozstd | awk '{print $NF}'); cd ${GOPATH}/pkg/mod/github.com/valyala/gozstd@${GOZSTD_VER}; if [[ ! -f _rebuilt ]]; then chmod -R +w .; make -j8 clean; make -j8 libzstd.a; touch _rebuilt; fi;
RUN make all

FROM alpine:3.12

RUN apk add --no-cache ca-certificates libgcc libstdc++ supervisor
COPY --from=builder /app/build/bin/* /usr/local/bin/

ENTRYPOINT [ "sh", "-c", "exec rpcdaemon \
    --private.api.addr=\"tg:9090\" \
    --http.addr=\"0.0.0.0\" \
    --http.vhosts=\"*\" \
    --http.corsdomain=\"*\" \
    --ws \
    --metrics \
    --metrics.addr=\"0.0.0.0\" \
    --metrics.port=\"6060\" \
    $RPCDAEMON_EXTRA_OPTS \
    " ]