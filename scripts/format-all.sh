#!/bin/bash
# This script must be executed in the root directory
${BASH_SOURCE%/*}/swift-latest.sh run --package-path ${BASH_SOURCE%/*}/../Tools swiftformat Sources Tests