import MessagePack
import XCTest

final class WriterTests: XCTestCase {
    func testNil() {
        assertPack("C0") { $0.packNil() }
    }

    func testWriteBoolean() {
        assertPack("C2") { $0.pack(false) }

        assertPack("C3") { $0.pack(true) }
    }

    func testWriteUInt() {
        assertPack("00") { $0.pack(0) }

        assertPack("01") { $0.pack(1) }

        assertPack("7F") { $0.pack(127) }
        assertPack("CC80") { $0.pack(128) }

        assertPack("CCFF") { $0.pack(255) }
        assertPack("CD0100") { $0.pack(256) }

        assertPack("CD7FFF") { $0.pack(32767) }
        assertPack("CD8000") { $0.pack(32768) }

        assertPack("CE80000000") { $0.pack(2_147_483_648) }

        assertPack("CF7FFFFFFFFFFFFFFF") { $0.pack(9_223_372_036_854_775_807) } // Max Int
        assertPack("CF8000000000000000") { $0.pack(UInt(9_223_372_036_854_775_808)) }

        assertPack("CFFFFFFFFFFFFFFFFF") { $0.pack(UInt(18_446_744_073_709_551_615)) } // Max UInt
    }

    func testWriteInt() {
        assertPack("FF") { $0.pack(-1) }

        assertPack("E0") { $0.pack(-32) }

        assertPack("D080") { $0.pack(-128) }
        assertPack("D1FF7F") { $0.pack(-129) }

        assertPack("D18000") { $0.pack(-32768) }
        assertPack("D2FFFF7FFF") { $0.pack(-32769) }

        assertPack("D280000000") { $0.pack(-2_147_483_648) }
        assertPack("D3FFFFFFFF7FFFFFFF") { $0.pack(-2_147_483_649) }

        assertPack("D38000000000000000") { $0.pack(-9_223_372_036_854_775_808) }
    }

    func testFloat() {
        assertPack("CA00000000") { $0.pack(Float(0.0)) }
        assertPack("CA3DCCCCCD") { $0.pack(Float(0.1)) }
        assertPack("CB3FB999999999999A") { $0.pack(Double(0.1)) }
        assertPack("CABDCCCCCD") { $0.pack(Float(-0.1)) }
        assertPack("CA42F6E979") { $0.pack(Float(123.456)) }
        assertPack("CB405EDD2F1A9FBE77") { $0.pack(Double(123.456)) }
    }

    func testWriteArray() throws {
        try assertPack("90") { try $0.pack([]) }
        try assertPack("91C0") { try $0.pack([nil]) }
        try assertPack("9102") { try $0.pack([2]) }
        try assertPack("920202") { try $0.pack([2, 2]) }
        try assertPack("91A3666F6F") { try $0.pack(["foo"]) }
    }

    func testWriteData() throws {
        var data = Data()
        data.append(contentsOf: [0xFA, 0xFB, 0xFC, 0xFD, 0xFE, 0xFF])
        try assertPack("C406FAFBFCFDFEFF") { try $0.pack(data) }
    }

    func testWriteMap() throws {
        try assertPack("80") { try $0.pack([:]) }
        try assertPack("81A3666F6FA3626172") { try $0.pack(["foo": "bar"]) }
        try assertPack("81A3666F6FC0") { try $0.pack(["foo": nil]) }
        try assertPack("810203") { try $0.pack([2: 3]) }
        // We can't test dicts with multiple keys easily as the order is not guaranteed in swift
    }

    func testWriteString() throws {
        try assertPack("A6666F6F626172") { try $0.pack("foobar") }
        try assertPack("A6464F4F626172") { try $0.pack("FOObar") }
        try assertPack("AA666F6FF09F988A626172") { try $0.pack("foo😊bar") }
    }

    func assertPack(_ expected: String, _ writer: MessagePackWriter, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(Data(hexString: expected), writer.data,
                       "Expected \(expected.uppercased()) Packed \(writer.data.hexString.uppercased())",
                       file: file, line: line)
    }

    func assertPack(_ expected: String, file: StaticString = #file, line: UInt = #line,
                    _ writerClosure: (inout MessagePackWriter) throws -> Void) rethrows {
        var writer = MessagePackWriter()
        try writerClosure(&writer)
        XCTAssertEqual(Data(hexString: expected), writer.data,
                       "Expected \(expected.uppercased()) Packed \(writer.data.hexString.uppercased())",
                       file: file, line: line)
    }
}
