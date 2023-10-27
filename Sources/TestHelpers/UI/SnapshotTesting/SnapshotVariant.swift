//
// Copyright © 2023 Stream.io Inc. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import XCTest

/// A Snapshot Variant is a combination of SnapshotTraits,
/// that will result in a snapshot test with multiple UITraitCollection's.
public struct SnapshotVariant {
    public let snapshotTraits: [SnapshotTrait]
    public var snapshotName: String {
        snapshotTraits.map(\.name).joined(separator: ".")
    }

    public var traits: UITraitCollection {
        UITraitCollection(traitsFrom: [UITraitCollection(displayScale: 1)] + snapshotTraits.map(\.trait))
    }
}

/// A Snapshot Trait is usually just a combination of a UITraitCollection and it's name.
public struct SnapshotTrait {
    public let name: String
    public let trait: UITraitCollection
}

public extension SnapshotVariant {
    // MARK: - Combinations

    public static let all: [SnapshotVariant] = {
        [smallDark, defaultLight, extraExtraExtraLargeLight, rightToLeftLayout]
    }()

    public static let onlyUserInterfaceStyles: [SnapshotVariant] = {
        [defaultLight, defaultDark]
    }()

    // MARK: - Variants

    public static let extraExtraExtraLargeLight: SnapshotVariant = {
        var traits = [extraExtraExtraLargeTrait]
        traits.append(lightTrait)
        return SnapshotVariant(snapshotTraits: traits)
    }()

    public static let defaultDark: SnapshotVariant = {
        var traits = [defaultTrait]
        traits.append(darkTrait)
        return SnapshotVariant(snapshotTraits: traits)
    }()

    public static let defaultLight: SnapshotVariant = {
        var traits = [defaultTrait]
        traits.append(lightTrait)
        return SnapshotVariant(snapshotTraits: traits)
    }()

    public static let smallDark: SnapshotVariant = {
        var traits = [smallTrait]
        traits.append(darkTrait)
        return SnapshotVariant(snapshotTraits: traits)
    }()

    public static let rightToLeftLayout = SnapshotVariant(snapshotTraits: [rightToLeftLayoutTrait, defaultTrait])

    // MARK: - Traits

    private static let extraExtraExtraLargeTrait = SnapshotTrait(
        name: "extraExtraExtraLarge",
        trait: UITraitCollection(preferredContentSizeCategory: .extraExtraExtraLarge)
    )
    private static let defaultTrait = SnapshotTrait(
        name: "default",
        trait: UITraitCollection(preferredContentSizeCategory: .large)
    )
    private static let smallTrait = SnapshotTrait(
        name: "small",
        trait: UITraitCollection(preferredContentSizeCategory: .small)
    )

    private static let lightTrait = SnapshotTrait(
        name: "light",
        trait: UITraitCollection(userInterfaceStyle: .light)
    )

    private static let darkTrait = SnapshotTrait(
        name: "dark",
        trait: UITraitCollection(userInterfaceStyle: .dark)
    )

    private static let rightToLeftLayoutTrait = SnapshotTrait(
        name: "rightToLeftLayout", trait: .init(layoutDirection: .rightToLeft)
    )
}

public extension Array where Element == SnapshotVariant {
    public static let all: [SnapshotVariant] = {
        SnapshotVariant.all
    }()

    public static let onlyUserInterfaceStyles: [SnapshotVariant] = {
        SnapshotVariant.onlyUserInterfaceStyles
    }()
}
#endif
