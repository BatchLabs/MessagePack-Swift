#!/bin/bash
rm Tests/MessagePackTests/XCTestManifests.swift
${BASH_SOURCE%/*}/swift-latest.sh test --generate-linuxmain