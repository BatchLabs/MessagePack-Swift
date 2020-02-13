#!/bin/bash

# Script that uses the latest switch toolchain if it is installed, and falls back on xcode's
# This is necessary because sourcekit-lsp needs another toolchain that the one in Xcode
# On linux, it just uses swift in the path
if [ -d "/Library/Developer/Toolchains/swift-latest.xctoolchain" ]
then
    xcrun --toolchain "Swift Latest" --run swift $@
else
    swift $@
fi