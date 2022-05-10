#!/usr/bin/env bash

bad() {
  ret=$1
  shift
  echo "$(red "● failed:")" "$@"
  exit $ret
}

cmd_exists() {
  type "$1" >/dev/null 2>&1
}

cmd_exists gover || bad 1 "gover missing: go install github.com/modocache/gover"
cmd_exists goveralls || bad 1 "goveralls missing: go install github.com/mattn/goveralls"

if [[ "$COVERALLS_TOKEN" == "" ]]
then
	echo COVERALLS_TOKEN not set
	exit 1
fi

go test -covermode count -coverprofile coverage.coverprofile

gover
goveralls -coverprofile gover.coverprofile -repotoken $COVERALLS_TOKEN
find . -name '*.coverprofile' -delete
