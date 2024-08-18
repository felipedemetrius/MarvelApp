//
//  FeedViewController+HelpersTests.swift
//  MarveliOSUiKitTests
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import UIKit
@testable import MarveliOSUiKit

extension FeedViewController {    
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
            prepareForFirstAppearance()
        }

        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }

    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func simulateTapOnErrorMessage() {
        errorView.simulateTap()
    }

    public var errorMessage: String? {
        errorView.message
    }

    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }

    private func prepareForFirstAppearance() {
        replaceRefreshControlWithSpyForiOS17Support()
    }

    private func replaceRefreshControlWithSpyForiOS17Support() {
        let spyRefreshControl = UIRefreshControlSpy()

        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                spyRefreshControl.addTarget(target, action: Selector(action), for: .valueChanged)
            }
        }

        refreshControl = spyRefreshControl
    }
}

private class UIRefreshControlSpy: UIRefreshControl {
    private var _isRefreshing = false

    override var isRefreshing: Bool { _isRefreshing }

    override func beginRefreshing() {
        _isRefreshing = true
    }

    override func endRefreshing() {
        _isRefreshing = false
    }
}
