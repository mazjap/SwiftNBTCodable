# SwiftNBTCodable

An NBT file decoder. Automatically decompresses via Gzip if necessary.

## Usage

```swift
import SwiftNBTCodable

if let filepath = Bundle.main.path(forResource: "level", ofType: "dat") { // Get file's path from bundle
    let data = try Data(contentsOf: URL(fileURLWithPath: filepath)) // Get file's data from path
    let decodedNBT = try decodeNBT(from: data) // Decode NBT data
}
```

## Installation

### XCode (via SPM)

Go to `file` > `Add Packages` > In the search bar, paste `https://github.com/mazjap/SwiftNBTCodable` and hit Add Package
