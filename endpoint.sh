#!/bin/bash

set -e -o pipefail

checklog() {
    cat /work/model.log
    if egrep --before-context=1 --max-count=1 "^r\([0-9]+\);$" "/work/model.log"
    then
        exit 1
    else
        exit 0
    fi
}

/work/bin/stata -b do /workspace/analysis/model.do

checklog
