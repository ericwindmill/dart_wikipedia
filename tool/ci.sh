#!/bin/bash

set -e

DIR="${BASH_SOURCE%/*}"
source "$DIR/flutter_ci_script_shared.sh"

flutter doctor -v

declare -ar PROJECTS=(
  "pkgs/cli"
  "pkgs/command_runner"
  "pkgs/flutter"
  "pkgs/server"
  "pkgs/wikipedia"
)

function ci_projects () {
  shift
  local arr=("$@")
  for PROJECT in "${arr[@]}"
  do
    echo "=== Testing ${PROJECT} ==="
    pushd "${PROJECT}"

    flutter pub get
    dart analyze --fatal-infos --fatal-warnings
    dart format --output none .

    if [ -d "test" ]
    then
      if grep -q "flutter:" "pubspec.yaml"; then
        flutter test
      else
        dart test
      fi
    fi

    popd
  done
}

ci_projects "${PROJECTS[@]}"

echo "=== Success ==="
