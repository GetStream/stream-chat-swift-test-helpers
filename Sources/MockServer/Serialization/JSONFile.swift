//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation

// MARK: JSON Parsing

/// Helper class for parsing JSON files
@objc
public final class JSONFile: NSObject {

    @objc public let filePath: String

    @objc public init(_ filePath: String) {
        self.filePath = filePath
    }

    /// Helper func that returns `Data` for json file at given `filePath`.
    ///
    /// Usage:
    ///       JSONFile("Comments_veryLongConversation").toData()
    @objc public func toData() -> Data? {
        guard let filePath = Bundle(for: Self.self).path(forResource: filePath, ofType: "json") else {
            return nil
        }

        do {
            return try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
        } catch {
            print("NetworkMockServer encountered parsing error: ", error)
            return nil
        }
    }

    /// Helper func that returns a Foundation object from given JSON file.
    ///
    /// Usage:
    ///       JSONFile("Comments_veryLongConversation").jsobObject
    @objc public var jsonObject: AnyObject? {
        guard let data = self.toData(),
              let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            assertionFailure("Could not convert data to json")
            return nil
        }
        return json as AnyObject
    }
}
