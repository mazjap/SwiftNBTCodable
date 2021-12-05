//
//  NBTTag.swift
//
//
//  Created by Jordan Christensen on 12/3/21.
//

import Foundation
import Gzip

public protocol NBTTag {
    var name: String? { get set }
    var data: Data { get set }
    var typeId: Int8 { get }
    
    init?(name: String?, data: Data)
    
//    func encode(compressed: Bool) throws -> Data
}

extension NBTTag {
    var value: TagValue! {
        try? .init(typeId, data: data)
    }
    
    init?(name: String?, _ d: inout Data) {
        self.init(name: name, data: d)

        _ = try? TagValue(typeId, data: &d)
    }
    
    static func tag(from data: Data) throws -> NBTTag {
        var copy: Data
        
        if data.isGzipped {
            copy = try data.gunzipped()
            
            copy.enumerated().forEach { (index, byte) in
                print("\(index): \(String(byte, radix: 16, uppercase: false)) | \(byte)")
            }
        } else {
            copy = data
        }
        
        return try tag(from: &copy)
    }
    
    static func tag(from data: inout Data) throws -> NBTTag {
        let typeId = try NBTDecoder.decodeByte(&data)
        
        print("\(data.startIndex)/\(data.endIndex): \(Float32(data.startIndex) / Float32(data.endIndex))")
        
        if typeId == TagValue.end.typeId || data.startIndex == data.endIndex {
            return NBTEnd()
        } else {
            let nameLength = Int(try NBTDecoder.decodeUShort(&data))
            let name: String?
            
            if nameLength > 0, let n = String(data: Data(try data.popFirst(nameLength)), encoding: .utf8) {
                name = n
                print(n)
            } else {
                name = nil
            }
            
            switch typeId {
            case 1:
                if let byte = NBTByte(name: name, &data) {
                    return byte
                }
            case 2:
                if let short = NBTShort(name: name, &data) {
                    return short
                }
            case 3:
                if let int = NBTInt(name: name, &data) {
                    return int
                }
            case 4:
                if let long = NBTLong(name: name, &data) {
                    return long
                }
            case 5:
                if let float = NBTFloat(name: name, &data) {
                    return float
                }
            case 6:
                if let double = NBTDouble(name: name, &data) {
                    return double
                }
            case 7:
                if let byteArray = NBTByteArray(name: name, &data) {
                    return byteArray
                }
            case 8:
                if let string = NBTString(name: name, &data) {
                    return string
                }
            case 9:
                if let list = NBTList(name: name, &data) {
                    return list
                }
            case 10:
                if let compound = NBTCompound(name: name, &data) {
                    return compound
                }
            case 11:
                if let array = NBTIntArray(name: name, &data) {
                    return array
                }
            case 12:
                if let array = NBTLongArray(name: name, &data) {
                    return array
                }
            default:
                NSLog("An unknown tag type (\(typeId)) was found. Please ensure the data you are decoding is valid NBT and then open an issue on github: https://github.com/mazjap/SwiftNBTCodable")
                throw NBTError.unknownTagType(typeId)
            }
            
            throw NBTError.badDecode()
        }
    }
}

public
indirect enum TagValue {
    case end
    case byte(Int8)
    case short(Int16)
    case int(Int32)
    case long(Int64)
    case float(Float32)
    case double(Float64)
    case byteArray([Int8])
    case string(String)
    case list([TagValue])
    case compound([NBTTag])
    case intArray([Int32])
    case longArray([Int64])
    
    var typeId: Int8 {
        switch self {
        case .end:
            return 0
        case .byte:
            return 1
        case .short:
            return 2
        case .int:
            return 3
        case .long:
            return 4
        case .float:
            return 5
        case .double:
            return 6
        case .byteArray:
            return 7
        case .string:
            return 8
        case .list:
            return 9
        case .compound:
            return 10
        case .intArray:
            return 11
        case .longArray:
            return 12
        }
    }
    
    init(_ tagType: Int8, data: Data) throws {
        var copy = data
        
        try self.init(tagType, data: &copy)
    }
    
    internal init(_ tagType: Int8, data: inout Data) throws {
        switch tagType {
        case 1: // Byte
            self = .byte(try NBTDecoder.decodeByte(&data))
        case 2: // Short
            self = .short(try NBTDecoder.decodeShort(&data))
        case 3: // Int
            self = .int(try NBTDecoder.decodeInt(&data))
        case 4: // Long
            self = .long(try NBTDecoder.decodeLong(&data))
        case 5: // Float
            self = .float(try NBTDecoder.decodeFloat(&data))
        case 6: // Double
            self = .double(try NBTDecoder.decodeDouble(&data))
        case 7: // Byte Array
            let length = try NBTDecoder.decodeInt(&data)
            
            self = .byteArray(
                try (0..<length).map { _ in
                    try NBTDecoder.decodeByte(&data)
                }
            )
        case 8: // String
            let length = Int(try NBTDecoder.decodeUShort(&data))
            
            if let str = String(data: Data(try data.popFirst(length)), encoding: .utf8) {
                self = .string(str)
            } else {
                throw NBTError.badDecode()
            }
        case 9: // List
            let listElementType = try NBTDecoder.decodeByte(&data)
            let listLength = try NBTDecoder.decodeInt(&data)
            
            var list = [TagValue]()
            
            for _ in (0..<listLength) {
                let tag = try Self(listElementType, data: &data)
                
                guard tag.typeId == listElementType else {
                    throw NBTError.badDecode(.invalidArrayElementType)
                }
                
                list.append(tag)
            }
            
            self = .list(list)
        case 10: // Compound
            var list = [NBTTag]()
            
            while data.startIndex != data.endIndex {
                let tag = try NBTEnd.tag(from: &data)
                
                list.append(tag)
                
                if tag is NBTEnd {
                    break
                }
            }
            
            self = .compound(list)
        case 11: // Int Array
            let arrLength = try NBTDecoder.decodeInt(&data)
            
//                var array = [NBTTag]()
            var intArray = [Int32]()
            
            for _ in 0..<arrLength {
                intArray.append(try NBTDecoder.decodeInt(&data))
                
//                    let tag = try Self(from: &data)
//
//                    guard tag.typeId == 3 else {
//                        throw NBTError.badDecode(.invalidArrayType)
//                    }
//
//                    array.append(tag)
            }
            
            self = .intArray(intArray)
        case 12: // Long Array
            let arrLength = try NBTDecoder.decodeInt(&data)
            
//                var array = [NBTTag]()
            var longArray = [Int64]()
            
            for _ in 0..<arrLength {
                longArray.append(try NBTDecoder.decodeLong(&data))
                
//                    let tag = try Self(from: &data)
//
//                    guard tag.typeId == 3 else {
//                        throw NBTError.badDecode(.invalidArrayType)
//                    }
//
//                    array.append(tag)
            }
            
            self = .longArray(longArray)
        default:
            NSLog("An unknown tag type (\(tagType)) was found. Please ensure the data you are decoding is valid NBT and then open an issue on github: https://github.com/mazjap/SwiftNBTCodable")
            throw NBTError.unknownTagType(tagType)
        }
    }
}
