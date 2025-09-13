//
//  CharacterCell+HelpersTests.swift
//  MarveliOSUiKitTests
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import UIKit
import MarveliOSUiKit

extension CharacterCell {
    func simulateRetryAction() {
        retryButton.simulateTap()
    }

    var isShowingImageLoadingIndicator: Bool {
        return imageContainer.isShimmering
    }

    var isShowingRetryAction: Bool {
        return !retryButton.isHidden
    }

    var nameText: String? {
        return name.text
    }

    var descriptionText: String? {
        return descriptionChar.text
    }

    var renderedImage: Data? {
        return imageChar.image?.pngData()
    }
}
