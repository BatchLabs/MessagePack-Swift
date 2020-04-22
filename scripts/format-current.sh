#!/bin/bash
# You need to pass the current file to swiftformat
${BASH_SOURCE%/*}/swift-latest.sh run --package-path ${BASH_SOURCE%/*}/../Tools swiftformat $@