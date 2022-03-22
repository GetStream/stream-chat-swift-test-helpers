//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
import Swifter
import StreamChatTestHelpers

public extension HttpResponseBody {

    /// Allows you to specify filepath to your snapshot json file
    /// - Note: This function returns an explicit non-optional data object, you'll be warned in form of crash if the json file is missing
    static func jsonFile(_ filePath: String) -> HttpResponseBody {
        .data(JSONFile(filePath).toData()!)
    }

    /// Allows you to specify filepath to your snapshot json file
    /// Deserializes filePath data into a JSON Object to be decoded
    static func jsonObject(_ filePath: String) -> HttpResponseBody {
        .json(JSONFile(filePath).jsonObject!)
    }
}
