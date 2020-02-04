#!/usr/bin/env bash

set -e

readonly _SQL_GRAPHVIZ="sql_graphviz"
readonly _GRAPHVIZ="graphviz"

function _build_sql_graphviz() {
  docker build --file - --tag "${_SQL_GRAPHVIZ}" . <<'EOF'
FROM python:alpine

RUN pip install pyparsing

COPY sql_graphviz.py .

ENTRYPOINT ["python", "sql_graphviz.py"]
EOF
}

function _build_dot() {
	docker build --file - --tag "${_GRAPHVIZ}" . <<'EOF'
FROM alpine
RUN apk add --update --no-cache graphviz
EOF
}

function main() {
  _build_sql_graphviz >&2
  _build_dot >&2

  docker run -i "${_SQL_GRAPHVIZ}" | docker run -i "${_GRAPHVIZ}" dot -Tsvg
}

main
