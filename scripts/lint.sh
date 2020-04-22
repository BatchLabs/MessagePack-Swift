#!/bin/bash
${BASH_SOURCE%/*}/swift-latest.sh run --package-path ${BASH_SOURCE%/*}/../Tools swiftlint $@