# Copyright &copy; 2024 Alexander Diemand
# Licensed under GPL-3; see [LICENSE](/LICENSE)

# docker buildx build --platform linux/amd64,linux/arm64 -f Dockerfile -t registry.cluster:5000/chain_index_btc:latest .
# with increasing version number in tag; push to private registry:
# docker buildx build --platform linux/amd64 -f Dockerfile -t registry.cluster:5000/chain_index_btc:amd64v8  . --load
# POD_NAME=$(kubectl get pods --namespace private-registry -l app=docker-registry,release=docker-registry -o jsonpath={.items[0].metadata.name})
# kubectl -n private-registry port-forward $POD_NAME 5000:5000
# docker push registry.cluster:5000/chain_index_btc:amd64v8

FROM debian:latest AS builder

RUN addgroup --gid 1000 bca && adduser --disabled-password --uid 1000 --gid 1000 bca

RUN apt update && apt upgrade -y && apt install -y opam bash git binutils texinfo automake autoconf less vim cmake gcc g++ gettext sed curl pkg-config libgmp-dev libffi-dev libcurl4-gnutls-dev

USER bca

WORKDIR /home/bca

RUN opam init --compiler 5.1.1 --disable-sandboxing --enable-shell-hook --shell-setup
RUN opam install -y dune lwt_ppx yojson ezcurl-lwt

COPY dune-project .
COPY bin ./bin/

RUN eval $(opam env); dune clean; dune build

FROM codieplusplus/duckdb-debian:v1.0.0 AS duckdb_container

FROM debian:latest

RUN addgroup --gid 1000 bca && adduser --disabled-password --uid 1000 --gid 1000 bca

RUN apt update && apt upgrade -y && apt install -y opam bash git less vim curl jq pkg-config libgmp-dev libffi-dev libcurl4-gnutls-dev

USER bca

WORKDIR /home/bca

#COPY --from=builder /home/bca/.opam /home/bca/.opam
COPY --from=builder /home/bca/_build /home/bca/_build

COPY --from=duckdb_container /home/squeak/duckdb /home/bca/.local/bin/

COPY dot.profile /home/bca/.profile
COPY duckdb /home/bca/duckdb

COPY lsblocks.sh json2duckdb.sh export_blocks_to_duckdb.sh /home/bca/

CMD [ "bash" ]
