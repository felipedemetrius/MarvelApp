//
//  Localized.swift
//  MarvelApp
//
//  Created by Felipe Demetrius Martins da Silva on 15/09/25.
//

import Foundation

public final class Localized {
    static var bundle: Bundle {
        Bundle(for: Localized.self)
    }
}

public extension Localized {
    enum Feed {
        static var table: String { "Localizable" }

        public static var title: String {
            NSLocalizedString(
                "FEED_VIEW_TITLE",
                tableName: table,
                bundle: bundle,
                comment: "Title for the feed view")
        }

        public static var loadError: String {
            NSLocalizedString(
                "FEED_VIEW_CONNECTION_ERROR",
                tableName: table,
                bundle: bundle,
                comment: "Error message displayed when we can't load the image feed from the server")
        }
    }
}
