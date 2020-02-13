#if !canImport(ObjectiveC)
    import XCTest

    extension DataStreamTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__DataStreamTests = [
            ("testBounds", testBounds),
            ("testPeekByte", testPeekByte),
            ("testReadByte", testReadByte),
            ("testReadMutipleBytes", testReadMutipleBytes),
            ("testReadNumerics", testReadNumerics),
            ("testSkip", testSkip),
        ]
    }

    extension ReaderTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__ReaderTests = [
            ("testArray", testArray),
            ("testBoolean", testBoolean),
            ("testData", testData),
            ("testDictionary", testDictionary),
            ("testFloat", testFloat),
            ("testInt", testInt),
            ("testNil", testNil),
            ("testString", testString),
            ("testUInt", testUInt),
        ]
    }

    extension WriterTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__WriterTests = [
            ("testFloat", testFloat),
            ("testNil", testNil),
            ("testWriteArray", testWriteArray),
            ("testWriteBoolean", testWriteBoolean),
            ("testWriteData", testWriteData),
            ("testWriteInt", testWriteInt),
            ("testWriteMap", testWriteMap),
            ("testWriteString", testWriteString),
            ("testWriteUInt", testWriteUInt),
        ]
    }

    public func __allTests() -> [XCTestCaseEntry] {
        [
            testCase(DataStreamTests.__allTests__DataStreamTests),
            testCase(ReaderTests.__allTests__ReaderTests),
            testCase(WriterTests.__allTests__WriterTests),
        ]
    }
#endif
