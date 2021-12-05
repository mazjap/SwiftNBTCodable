//
//  NBTError.swift
//
//
//  Created by Jordan Christensen on 12/4/21.
//

import Foundation

public enum NBTError: LocalizedError {
    case noData
    case badDecode(DecodeError? = nil)
    case unknownTagType(Int8)
    
    public var errorDescription: String? {
        switch self {
        case .noData:
            return "The data provided was empty"
        case let .badDecode(decodeError):
            if let message = decodeError?.errorDescription {
                return message
            }
            
            return "The data could not be properly decoded"
        case let .unknownTagType(id):
            return "Found an unknown tag id: \(id)"
        }
    }
    
    public enum DecodeError: LocalizedError {
        case cannotDecompress
        case invalidArrayElementType
        
        public var errorDescription: String? {
            switch self {
            case .cannotDecompress:
                return "The data compression type appears to be GZIP, but there was a problem trying to decompress the data"
            case .invalidArrayElementType:
                return "An element of the array is not the correct type"
            }
        }
    }
}
