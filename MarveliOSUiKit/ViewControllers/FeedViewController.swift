//
//  FeedViewController.swift
//  MarveliOSUiKit
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import UIKit
import MarvelLoader
import Combine

public final class FeedViewController: UITableViewController {
    private var bag = Set<AnyCancellable>()
    private(set) public var errorView = ErrorView()
    private var onViewIsAppearing: (() -> Void)?

    var viewModel: FeedViewModel?
    
    public convenience init (viewModel: FeedViewModel) {
        self.init()
        self.viewModel = viewModel
        bind()
    }
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        onViewIsAppearing = { [weak self] in
            self?.load()
            self?.onViewIsAppearing = nil
        }
    }
    
    deinit {
        bag.forEach { $0.cancel() }
        bag.removeAll()
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        onViewIsAppearing?()
    }

    @objc private func load() {
        viewModel?.onErrorStateChange.send(.none)
        viewModel?.loadFeed()
    }
    
    private func bind() {
        title = viewModel?.title
        viewModel?.onLoadingStateChange.sink { [weak self] isLoading in
            if isLoading {
                self?.refreshControl?.beginRefreshing()
            } else {
                self?.refreshControl?.endRefreshing()
            }
        }.store(in: &bag)

        viewModel?.onErrorStateChange.sink { [weak self] errorMessage in
            self?.errorView.message = errorMessage
        }.store(in: &bag)
    }
}
