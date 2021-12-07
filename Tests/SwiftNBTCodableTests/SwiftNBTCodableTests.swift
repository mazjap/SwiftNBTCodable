import XCTest
@testable import SwiftNBTCodable

final class SwiftNBTCodableTests: XCTestCase {
    lazy var testNBT: NBTTag = {
        NBTCompound(
            name: "Compound",
            value: [
                NBTCompound(
                    name: "Tests",
                    value: [
                        NBTByte(name: "Byte", value: Int8.max),
                        NBTShort(name: "Short", value: Int16.max),
                        NBTInt(name: "Int", value: Int32.max),
                        NBTLong(name: "Long", value: Int64.max),
                        NBTFloat(name: "Float", value: Float32.greatestFiniteMagnitude),
                        NBTDouble(name: "Double", value: Float64.greatestFiniteMagnitude),
                        NBTByteArray(name: "ByteArray", value: [1, 2, 3, 4, 5]),
                        NBTList(name: "List", value: [
                            .float(1.1),
                            .float(1.2),
                            .float(1.3),
                            .float(1.4),
                            .float(1.5),
                            .end
                        ]),
                        NBTEnd()
                    ]
                )
            ]
        )
    }()
    
    func testDecode() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertTrue(true)
    }
    
    @discardableResult
    func testEncode() throws -> Data {
        let data = try? testNBT.encode(compressed: true)
        XCTAssertNotNil(data)
        
        return data!
    }
}
