# MessagePack

Pure Swift 5 MessagePack library, compatible with macOS, iOS and Linux.

This library does not attempt to implement Codable for simplicity.

## Reading

The library implements type-safe lazy readers. See `read(_: Type)` for more information.

Supported types are:  
- Bool,
- UInt/8/16/32/64,
- Int/8/16/32/64,
- Float,
- Double,
- String,
- Data

Specialized methods are available to read nil, arrays and dictionaries.  
Optional helpers are available using `read(_: Type?)` and `readOptional*`.

Example:
```Swift
let data: Data = ......
var reader = MessagePackReader(from: data)
let age = try reader.read(UInt8.self)
let name = try reader.read(String.self)
let subscribed = try reader.read(Bool?.self)
```

### Reading arrays and dictionaries

While you can eagerly read arrays and dictionaries using `readArray` and `readDictionary`, they return `[Any?]` and `[AnyHashable: Any?]`,
which require you to carefuly cast the results.
This also doesn't support "complex" arrays/maps where the index might represent more than one MessagePack value, which an automatic reader can't know.

To read arrays/maps in a type safe way, this library implements a closure based reader which works like `.map`.  
Alternatively, you can simply read the array/map length and proceed manually, using `readArrayHeader`

Example:
```Swift
struct Person {
    var name: String
    var age: UInt8
}

let data: Data = ......
var reader = MessagePackReader(from: data)
let count: [Person] = try reader.readAndMapArray {
    let name = try $0.read(String.self)
    let age = try $0.read(UInt8.self)
    return Person(name: name, age: age)
}
```

## Writing

The library implements type-safe writers. See `pack(_: Type)` for more information.

Supported types are:  
- Bool,
- UInt/8/16/32/64,
- Int/8/16/32/64,
- Float,
- Double,
- String,
- Data

Specialized methods are available to write nil, arrays, dictionaries and any.  

The output data is always available by reading the `data` property.

Example:
```Swift
var writer = MessagePackWriter()
writer.pack(Int32(-4))
writer.pack(UInt8(40))
writer.pack("MessagePack")
let packedData = writer.data
```

### Writing an optional

To make sure you don't accidentally pack nil values, optional methods are suffixed by "Optional".

```Swift
let value: String? = nil
var writer = MessagePackWriter()
writer.packOptional(value)
```

### Writing an array/dictionary

While you can pack arrays and dictionaries using `packArray` and `packDictionary`, you might need to write "complex" values.  
`packFlatArray`/`packFlatDictionary` allows you to pack such values.

Example that packs the Person array read by the reader example:  
```Swift
var writer = MessagePackWriter()
var persons = [MessagePackFlatValue]()
// MessagePackFlatValue is a great candidate to map your original collection to
persons.append(try MessagePackFlatValue {
    $0.pack("John Doe")
    $0.pack(35)
})
persons.append(try MessagePackFlatValue {
    $0.pack("Jane Doe")
    $0.pack(26)
})
try writer.packFlatArray(persons) 
let data = writer.data
```

>Note: MessagePackValue cannot be packed using `pack(_: [Any?].Type)`, as mixing "simple" and "complex" types is usually not wanted.

## Extensions

Extensions are currently not supported.  
If you can pack/unpack them manuallyn use `unsafePackRawData(_: Data)`/`unsafePeekRawByte()` or `unsafeReadRawData()`.

## Developing the library

Simply open `Package.swift` in Xcode. Development in VSCode is also supported even on linux.  
Scripts are available in the `scripts/` folder, which include building, testing and running SwiftFormat/Swiftlint.  

This project uses SwiftFormat and Swiftlint, which are automatically installed locally by SwiftPM: use the provided shell scripts (or vscode tasks) to run them.