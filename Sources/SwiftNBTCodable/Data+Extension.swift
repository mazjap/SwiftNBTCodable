//
//  File.swift
//
//
//  Created by Jordan Christensen on 12/3/21.
//

import Foundation

extension Data {
    mutating func popFirst(_ length: Int) throws -> [UInt8] {
        var mutableLength = length
        var arr = [UInt8]()
        
        while mutableLength > 0, let currentByte = popFirst() {
            arr.append(currentByte)
            mutableLength -= 1
        }
        
        if arr.count != length {
            throw NBTError.noData
        }
        
        return arr
    }
}
