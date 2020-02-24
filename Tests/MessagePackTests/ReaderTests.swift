import MessagePack
import XCTest

// swiftlint:disable force_cast

final class ReaderTests: XCTestCase {
    func testNil() throws {
        assertUnpack("C0", nil as Bool?) {
            try $0.readNil()
            return nil
        }
    }

    func testBoolean() throws {
        assertUnpack("C2", false) { try $0.read(Bool.self) }
        assertUnpack("C3", true) { try $0.read(Bool.self) }
    }

    func testUInt() {
        assertUnpack("00", 0) { try $0.read(UInt.self) }

        assertUnpack("01", 1) { try $0.read(UInt.self) }

        assertUnpack("7F", 127) { try $0.read(UInt.self) }
        assertUnpack("CC80", 128) { try $0.read(UInt.self) }

        assertUnpack("CCFF", 255) { try $0.read(UInt.self) }
        assertUnpack("CD0100", 256) { try $0.read(UInt.self) }

        assertUnpack("CD7FFF", 32767) { try $0.read(UInt.self) }
        assertUnpack("CD8000", 32768) { try $0.read(UInt.self) }

        assertUnpack("CE80000000", 2_147_483_648) { try $0.read(UInt.self) }

        assertUnpack("CF7FFFFFFFFFFFFFFF", 9_223_372_036_854_775_807) { try $0.read(UInt.self) } // Max Int
        assertUnpack("CF8000000000000000", UInt(9_223_372_036_854_775_808)) { try $0.read(UInt.self) }

        assertUnpack("CFFFFFFFFFFFFFFFFF", UInt64(18_446_744_073_709_551_615)) { try $0.read(UInt64.self) } // Max UInt
    }

    func testInt() {
        assertUnpack("7F", 127) { try $0.read(Int.self) }

        assertUnpack("FF", -1) { try $0.read(Int.self) }

        assertUnpack("E0", -32) { try $0.read(Int.self) }

        assertUnpack("D080", -128) { try $0.read(Int.self) }
        assertUnpack("D1FF7F", -129) { try $0.read(Int.self) }

        assertUnpack("D18000", -32768) { try $0.read(Int.self) }
        assertUnpack("D2FFFF7FFF", -32769) { try $0.read(Int.self) }

        assertUnpack("D280000000", -2_147_483_648) { try $00.read(Int.self) }
        assertUnpack("D3FFFFFFFF7FFFFFFF", -2_147_483_649) { try $0.read(Int.self) }

        assertUnpack("D38000000000000000", Int64(-9_223_372_036_854_775_808)) { try $0.read(Int64.self) }
    }

    func testFloat() {
        assertUnpack("CA00000000", Float(0.0)) { try $0.read(Float.self) }
        assertUnpack("CA3DCCCCCD", Float(0.1)) { try $0.read(Float.self) }
        assertUnpack("CB3FB999999999999A", Double(0.1)) { try $0.read(Double.self) }
        assertUnpack("CABDCCCCCD", Float(-0.1)) { try $0.read(Float.self) }
        assertUnpack("CA42F6E979", Float(123.456)) { try $0.read(Float.self) }
        assertUnpack("CB405EDD2F1A9FBE77", Double(123.456)) { try $0.read(Double.self) }
    }

    func testArray() throws {
        assertUnpack("90", []) { try $0.readArray() as! [Int64?] }
        assertUnpack("91C0", [nil]) { try $0.readArray() as! [Int64?] }
        assertUnpack("92C002", [nil, 2]) { try $0.readArray() as! [Int64?] }
        assertUnpack("9102", [2]) { try $0.readArray() as! [Int64] }
        assertUnpack("920202", [2, 2]) { try $0.readArray() as! [Int64] }
        assertUnpack("91A3666F6F", ["foo"]) { try $0.readArray() as! [String] }
    }

    func testData() throws {
        var data = Data()
        data.append(contentsOf: [0xFA, 0xFB, 0xFC, 0xFD, 0xFE, 0xFF])
        assertUnpack("C406FAFBFCFDFEFF", data) { try $0.read(Data.self) }
    }

    func testDictionary() throws {
        assertUnpack("80", [:]) { try $0.readDictionary() as! [AnyHashable: String] }
        assertUnpack("81A3666F6FA3626172", ["foo": "bar"]) { try $0.readDictionary() as! [AnyHashable: String] }
        assertUnpack("81A3666F6FC0", ["foo": nil]) { try $0.readDictionary() as! [AnyHashable: String?] }
        assertUnpack("810203", [2: 3]) { try $0.readDictionary() as! [AnyHashable: Int64] }
        // We can't test dicts with multiple keys easily as the order is not guaranteed in swift
    }

    func testString() throws {
        assertUnpack("A6666F6F626172", "foobar") { try $0.read(String.self) }
        assertUnpack("A6464F4F626172", "FOObar") { try $0.read(String.self) }
        assertUnpack("AA666F6FF09F988A626172", "foo😊bar") { try $0.read(String.self) }
    }

    func assertUnpack<T: Equatable>(_ hexData: String, _ expected: T, file: StaticString = #file, line: UInt = #line,
                                    _ readerClosure: (inout MessagePackReader) throws -> T) {
        var reader = MessagePackReader(from: Data(hexString: hexData))
        let value: T
        do {
            value = try readerClosure(&reader)
            XCTAssertEqual(expected, value,
                           "Expected \(expected), got \(value)",
                           file: file, line: line)
        } catch let err {
            XCTFail("Unpacking \(hexData) threw error '\(err)'", file: file, line: line)
        }
    }
}
