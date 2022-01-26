#!/usr/bin/env sh

if [ ! -x "$(which swagger2markup)" ]; then
  case $(uname) in
  Linux)
    echo "apt install swagger2markup-cli"
    echo "yum install swagger2markup-cli"
    exit 1
    ;;
  Darwin)
    brew install swagger2markup-cli
    ;;
  esac
fi

if [ ! -x "$(which asciidoctor)" ]; then
  case $(uname) in
  Linux)
    echo "apt install asciidoctor"
    echo "yum install asciidoctor"
    exit 1
    ;;
  Darwin)
    brew install asciidoctor
    ;;
  esac
fi

if [ 0 -lt $? ]; then
  echo "Dependency error"
  exit 1
fi

[ "$1" = "-url" ] && url=$2
[ "$3" = "-url" ] && url=$4
[ "$1" = "-type" ] && type=$2
[ "$3" = "-type" ] && type=$4

if [ -z "$url" ]; then
  echo "Usage: $0 -url http://localhost/swagger.json [-type pdf|html, default=pdf]"
  exit 2
fi

if [ -z "$type" ]; then
  type="pdf"
fi

mkdir -p output

curl -sS -o output/swagger.json $url
if [ 0 -lt $? ]; then
  echo "Get swagger json fail. Please check."
  exit 1
fi

swagger2markup convert -i output/swagger.json -d ./output
tee ./output/index.adoc <<EOF
include::overview.adoc[]
include::paths.adoc[]
include::definitions.adoc[]
EOF

case $type in
    html)
        asciidoctor ./output/index.adoc -D ./output
        ;;
    *)
        asciidoctor-pdf -a pdf-style=themes/basic-theme.yml -a pdf-fontsdir=fonts/ ./output/index.adoc -D ./output
        ;;
esac

if [ 0 -eq $? ]; then
  echo "$type doc: ./output/index.$type"
fi
