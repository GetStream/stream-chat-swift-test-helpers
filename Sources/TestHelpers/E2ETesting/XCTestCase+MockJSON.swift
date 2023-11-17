//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import XCTest

extension XCTestCase {
    /// Loads a data from a file.
    /// - Parameters:
    ///   - name: a file name.
    ///   - extension: a file extension. JSON by default.
    /// - Returns: a file data.
    public static func mockData(fromFile name: String, bundle: Bundle, extension: String = "json") -> Data {
        guard let url = bundle.url(forResource: name, withExtension: `extension`) else {
            XCTFail("\n❌ Mock file \"\(name).json\" not found in bundle \(bundle.bundleURL.lastPathComponent)")
            return .init()
        }
        
        return try! Data(contentsOf: url)
    }
}
