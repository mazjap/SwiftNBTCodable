//
//  TagTypes.swift
//
//
//  Created by Jordan Christensen on 12/4/21.
//

import Foundation

public struct NBTEnd: NBTTag {
    public var name: String?
    public var data: Data
    public let typeId: Int8 = 0
    
    public init() {
        self.name = nil
        self.data = Data()
    }
    
    public init?(name: String?, data: Data) {
        self.init()
    }
}

public struct NBTByte: NBTTag {
    public var name: String?
    public var data: Data
    public let typeId: Int8 = 1
    
    public var signedValue: Int8! {
        if case let .byte(byte) = value {
            return byte
        }
        
        return nil
    }
    
    public var usignedValue: UInt8! {
        UInt8(bitPattern: signedValue)
    }
    
    public init?(name: String?, data: Data) {
        self.name = name
        self.data = data

        guard value?.typeId == typeId else {
            return nil
        }
    }
    
    public init(name: String?, value: UInt8) {
        self.init(name: name, data: Data([value]))!
    }
    
    public init(name: String?, value: Int8) {
        self.init(name: name, value: UInt8(bitPattern: value))
    }
}

public struct NBTShort: NBTTag {
    public var name: String?
    public var data: Data
    public let typeId: Int8 = 2
    
    public var signedValue: Int16! {
        if case let .short(short) = value {
            return short
        }
        
        return nil
    }
    
    public var unsignedValue: UInt16! {
        UInt16(bitPattern: signedValue)
    }
    
    public init?(name: String?, data: Data) {
        self.name = name
        self.data = data

        guard value?.typeId == typeId else {
            return nil
        }
    }
    
    public init(name: String?, value: UInt16) {
        var value = value
        let data = Data(bytes: &value, count: MemoryLayout<UInt16>.size)
        
        self.init(name: name, data: data)!
    }
    
    public init(name: String?, value: Int16) {
        self.init(name: name, value: UInt16(bitPattern: value))
    }
}

public struct NBTInt: NBTTag {
    public var name: String?
    public var data: Data
    public let typeId: Int8 = 3
    
    public var signedValue: Int32! {
        if case let .int(int) = value {
            return int
        }
        
        return nil
    }
    
    public var unsignedValue: UInt32! {
        UInt32(bitPattern: signedValue)
    }
    
    public init?(name: String?, data: Data) {
        self.name = name
        self.data = data

        guard value?.typeId == typeId else {
            return nil
        }
    }
    
    public init(name: String?, value: UInt32) {
        var value = value
        
        let data = Data(bytes: &value, count: MemoryLayout<UInt32>.size)
        
        self.init(name: name, data: data)!
    }
    
    public init(name: String?, value: Int32) {
        self.init(name: name, value: UInt32(bitPattern: value))
    }
}

public struct NBTLong: NBTTag {
    public var name: String?
    public var data: Data
    public let typeId: Int8 = 4
    
    public var signedValue: Int64! {
        if case let .long(long) = value {
            return long
        }
        
        return nil
    }
    
    public var unsignedValue: UInt64! {
        UInt64(bitPattern: signedValue)
    }
    
    public init?(name: String?, data: Data) {
        self.name = name
        self.data = data

        guard value?.typeId == typeId else {
            return nil
        }
    }
    
    public init(name: String?, value: UInt64) {
        var value = value
        
        let data = Data(bytes: &value, count: MemoryLayout<UInt64>.size)
        
        self.init(name: name, data: data)!
    }
    
    public init(name: String?, value: Int64) {
        self.init(name: name, value: UInt64(bitPattern: value))
    }
}

public struct NBTFloat: NBTTag {
    public var name: String?
    public var data: Data
    public let typeId: Int8 = 5
    
    public var decimalValue: Float32! {
        if case let .float(float) = value {
            return float
        }
        
        return nil
    }
    
    public init?(name: String?, data: Data) {
        self.name = name
        self.data = data

        guard value?.typeId == typeId else {
            return nil
        }
    }
    
    public init(name: String?, value: Float32) {
        var value = value
        
        let data = Data(bytes: &value, count: MemoryLayout<Float32>.size)
        
        self.init(name: name, data: data)!
    }
}

public struct NBTDouble: NBTTag {
    public var name: String?
    public var data: Data
    public let typeId: Int8 = 6
    
    public var decimalValue: Float64! {
        if case let .double(double) = value {
            return double
        }
        
        return nil
    }
    
    public init?(name: String?, data: Data) {
        self.name = name
        self.data = data

        guard value?.typeId == typeId else {
            return nil
        }
    }
    
    public init(name: String?, value: Float64) {
        var value = value
        
        let data = Data(bytes: &value, count: MemoryLayout<Float64>.size)
        
        self.init(name: name, data: data)!
    }
}

public struct NBTByteArray: NBTTag {
    public var name: String?
    public var data: Data
    public let typeId: Int8 = 7
    
    public var arrayValue: [Int8]! {
        if case let .byteArray(array) = value {
            return array
        }
        
        return nil
    }
    
    public init?(name: String?, data: Data) {
        self.name = name
        self.data = data

        guard value?.typeId == typeId else {
            return nil
        }
    }
    
    public init(name: String?, value: [Int8]) {
        self.init(name: name, data: Data(value.map(UInt8.init(bitPattern:))))!
    }
}

public struct NBTString: NBTTag {
    public var name: String?
    public var data: Data
    public let typeId: Int8 = 8
    
    public var stringValue: String! {
        if case let .string(string) = value {
            return string
        }
        
        return nil
    }
    
    public init?(name: String?, data: Data) {
        self.name = name
        self.data = data

        guard value?.typeId == typeId else {
            return nil
        }
    }
    
    /// Value must be encodable to utf8
    public init?(name: String?, value: String) {
        if let data = value.data(using: .utf8) {
            self.init(name: name, data: data)
        } else {
            return nil
        }
    }
}

public struct NBTList: NBTTag {
    public var name: String?
    public var data: Data
    public let typeId: Int8 = 9
    
    public var arrayValue: [TagValue]! {
        if case let .list(array) = value {
            return array
        }
        
        return nil
    }
    
    public init?(name: String?, data: Data) {
        self.name = name
        self.data = data

        guard value?.typeId == typeId else {
            return nil
        }
    }
    
    public init(name: String?, value: [TagValue]) {
        self.init(name: name, data: value.withUnsafeBytes { $0.load(as: Data.self) })!
    }
}

public struct NBTCompound: NBTTag {
    public var name: String?
    public var data: Data
    public let typeId: Int8 = 10
    
    public var arrayValue: [NBTTag]! {
        if case let .compound(array) = value {
            return array
        }
        
        return nil
    }
    
    public init?(name: String?, data: Data) {
        self.name = name
        self.data = data

        guard value?.typeId == typeId else {
            return nil
        }
    }
    
    public init(name: String?, value: [NBTTag]) {
        self.init(
            name: name,
            data: value.reduce(
                Data(),
                {
                    $0 + ((try? $1.encode(compressed: false)) ?? Data())
                }
            )
        )!
    }
}

public struct NBTIntArray: NBTTag {
    public var name: String?
    public var data: Data
    public let typeId: Int8 = 11
    
    public var arrayValue: [Int32]! {
        if case let .intArray(array) = value {
            return array
        }
        
        return nil
    }
    
    public init?(name: String?, data: Data) {
        self.name = name
        self.data = data

        guard value?.typeId == typeId else {
            return nil
        }
    }
    
    public init(name: String?, value: [Int32]) {
        self.init(
            name: name,
            data: value.reduce(
                Data(),
                {
                    var value = $1
                    return $0 + Data(bytes: &value, count: MemoryLayout<Int32>.size)
                }
            )
        )!
    }
}

public struct NBTLongArray: NBTTag {
    public var name: String?
    public var data: Data
    public let typeId: Int8 = 12
    
    public var arrayValue: [Int64]! {
        if case let .longArray(array) = value {
            return array
        }
        
        return nil
    }
    
    public init?(name: String?, data: Data) {
        self.name = name
        self.data = data

        guard value?.typeId == typeId else {
            return nil
        }
    }
    
    public init(name: String?, value: [Int64]) {
        self.init(
            name: name,
            data: value.reduce(
                Data(), {
                    var value = $1
                    return $0 + Data(bytes: &value, count: MemoryLayout<Int64>.size)
                }
            )
        )!
    }
}
