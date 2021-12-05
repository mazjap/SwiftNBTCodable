//
//  NBTDecoder.swift
//
//
//  Created by Jordan Christensen on 12/3/21.
//

import Foundation

enum NBTDecoder {
    static func decodeUByte(_ data: inout Data) throws -> UInt8 {
        guard let value = data.popFirst() else {
            throw NBTError.noData
        }
        
        return UInt8(bigEndian: value)
    }
    
    static func decodeByte(_ data: inout Data) throws -> Int8 {
        Int8(bitPattern: try decodeUByte(&data))
    }
    
    static func decodeUShort(_ data: inout Data) throws -> UInt16 {
        UInt16(
            bigEndian: try data.popFirst(2)
                .withUnsafeBytes {
                    $0.load(as: UInt16.self)
                }
        )
    }
    
    static func decodeShort(_ data: inout Data) throws -> Int16 {
        Int16(bitPattern: try decodeUShort(&data))
    }
    
    static func decodeUInt(_ data: inout Data) throws -> UInt32 {
        UInt32(
            bigEndian: try data.popFirst(4)
                .withUnsafeBytes {
                    $0.load(as: UInt32.self)
                }
        )
    }
    
    static func decodeInt(_ data: inout Data) throws -> Int32 {
        Int32(bitPattern: try decodeUInt(&data))
    }
    
    static func decodeULong(_ data: inout Data) throws -> UInt64 {
        UInt64(
            bigEndian: try data.popFirst(8)
                .withUnsafeBytes {
                    $0.load(as: UInt64.self)
                }
        )
    }
    
    static func decodeLong(_ data: inout Data) throws -> Int64 {
        Int64(bitPattern: try decodeULong(&data))
    }
    
    static func decodeFloat(_ data: inout Data) throws -> Float32 {
        try data.popFirst(4)
            .withUnsafeBytes {
                $0.load(as: Float32.self)
            }
    }
    
    static func decodeDouble(_ data: inout Data) throws -> Float64 {
        try data.popFirst(8)
            .withUnsafeBytes {
                $0.load(as: Float64.self)
            }
    }
    
    static func decodeUBytePreview(_ data: Data) throws -> UInt8 {
        var copy = data
        
        return try decodeUByte(&copy)
    }
    
    static func decodeBytePreview(_ data: Data) throws -> Int8 {
        var copy = data
        
        return try decodeByte(&copy)
    }
    
    static func decodeUShortPreview(_ data: Data) throws -> UInt16 {
        var copy = data
        
        return try decodeUShort(&copy)
    }
    
    static func decodeShortPreview(_ data: Data) throws -> Int16 {
        var copy = data
        
        return try decodeShort(&copy)
    }
    
    static func decodeUIntPreview(_ data: Data) throws -> UInt32 {
        var copy = data
        
        return try decodeUInt(&copy)
    }
    
    static func decodeIntPreview(_ data: Data) throws -> Int32 {
        var copy = data
        
        return try decodeInt(&copy)
    }
    
    static func decodeULongPreview(_ data: Data) throws -> UInt64 {
        var copy = data
        
        return try decodeULong(&copy)
    }
    
    static func decodeLongPreview(_ data: Data) throws -> Int64 {
        var copy = data
        
        return try decodeLong(&copy)
    }
    
    static func decodeFloatPreview(_ data: Data) throws -> Float32 {
        var copy = data
        
        return try decodeFloat(&copy)
    }
    
    static func decodeDoublePreview(_ data: Data) throws -> Float64 {
        var copy = data
        
        return try decodeDouble(&copy)
    }
}
