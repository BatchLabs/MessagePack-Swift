@testable import MessagePack
import XCTest

final class DataStreamTests: XCTestCase {
    func testReadByte() {
        let byte: UInt8 = 0xFE
        var reader = DataStreamReader(from: Data([byte]))
        XCTAssertEqual(byte, try reader.readByte())
    }

    func testReadMutipleBytes() {
        let byte: UInt8 = 0xFB
        var reader = DataStreamReader(from: Data([byte, byte, byte]))
        XCTAssertEqual([byte, byte, byte], [UInt8](try reader.readBytes(count: 3)))
    }

    func testPeekByte() {
        let byte: UInt8 = 0xFE
        var reader = DataStreamReader(from: Data([byte]))
        XCTAssertEqual(byte, try reader.peekByte())
        XCTAssertEqual(byte, try reader.readByte())
    }

    func testBounds() {
        let byte: UInt8 = 0xFE
        var reader = DataStreamReader(from: Data([byte, byte, byte]))
        XCTAssertThrowsError(try reader.readBytes(count: 4))
        for _ in 1 ... 3 {
            reader.skipByte()
        }
        XCTAssertThrowsError(try reader.readByte())
    }

    func testSkip() {
        let expectedByte: UInt8 = 0xFE
        var reader = DataStreamReader(from: Data([UInt8(0xFB), expectedByte]))
        reader.skipByte()
        XCTAssertEqual(expectedByte, try reader.readByte())
    }

    func testReadNumerics() {
        var reader: DataStreamReader

        let uint8 = UInt8.max
        reader = makeReader(forInteger: uint8)
        XCTAssertEqual(uint8, try reader.read(UInt8.self))
        let uint16 = UInt16.max
        reader = makeReader(forInteger: uint16)
        XCTAssertEqual(uint16, try reader.read(UInt16.self))
        let uint32 = UInt32.max
        reader = makeReader(forInteger: uint32)
        XCTAssertEqual(uint32, try reader.read(UInt32.self))
        let uint64 = UInt64.max
        reader = makeReader(forInteger: uint64)
        XCTAssertEqual(uint64, try reader.read(UInt64.self))

        let int8 = Int8.max
        reader = makeReader(forInteger: int8)
        XCTAssertEqual(int8, try reader.read(Int8.self))
        let int16 = Int16.max
        reader = makeReader(forInteger: int16)
        XCTAssertEqual(int16, try reader.read(Int16.self))
        let int32 = Int32.max
        reader = makeReader(forInteger: int32)
        XCTAssertEqual(int32, try reader.read(Int32.self))
        let int64 = Int64.min
        reader = makeReader(forInteger: int64)
        XCTAssertEqual(int64, try reader.read(Int64.self))
    }

    func makeReader<T: FixedWidthInteger>(forInteger integer: T) -> DataStreamReader {
        var bigEndianInteger = integer.bigEndian
        var data = Data()
        data.append(UnsafeBufferPointer(start: &bigEndianInteger, count: 1))
        return DataStreamReader(from: data)
    }
}
