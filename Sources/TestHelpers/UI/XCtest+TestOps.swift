//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import XCTest

public extension XCTest {
    
    func linkToScenario(withId: Int) {
        label(name: "AS_ID", values: [String(withId)])
    }
    
    func addTagsToScenario(_ tags: [String]) {
        label(name: "tag", values: tags)
    }
    
    private func label(name: String, values: [String]) {
        for value in values {
            XCTContext.runActivity(
                named: "allure.label.\(name):\(value)",
                block: {_ in}
            )
        }
    }

}
