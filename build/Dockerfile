
FROM golang:1.15-alpine3.12 as builder

ARG UPSTREAM_VERSION 
RUN apk add --no-cache make gcc g++ linux-headers git

WORKDIR /usr/src/app

RUN git clone -b ${UPSTREAM_VERSION} --recurse-submodules -j8 https://github.com/ledgerwatch/turbo-geth.git /usr/src/app
RUN go mod download
RUN GOZSTD_VER=$(cat go.mod | fgrep github.com/valyala/gozstd | awk '{print $NF}'); cd ${GOPATH}/pkg/mod/github.com/valyala/gozstd@${GOZSTD_VER}; if [[ ! -f _rebuilt ]]; then chmod -R +w .; make -j8 clean; make -j8 libzstd.a; touch _rebuilt; fi;
RUN make all

FROM alpine:3.12

RUN apk add --no-cache ca-certificates libgcc libstdc++
COPY --from=builder /usr/src/app/build/bin/* /usr/local/bin/

COPY entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT [ "entrypoint" ]
