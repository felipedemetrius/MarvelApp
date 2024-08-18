//
//  FeedViewController.swift
//  MarveliOSUiKit
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import UIKit
import MarvelLoader
import Combine

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private var bag = Set<AnyCancellable>()
    private(set) public var errorView = ErrorView()
    private var onViewIsAppearing: (() -> Void)?

    var viewModel: FeedViewModel?
    
    var tableModel = [CharacterCellController]() {
        didSet { tableView.reloadData() }
    }

    public convenience init (viewModel: FeedViewModel) {
        self.init()
        self.viewModel = viewModel
        bind()
    }
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
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
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.tableHeaderView = errorView.makeContainer()
        tableView.register(CharacterCell.self, forCellReuseIdentifier: "CharacterCell")

        errorView.onHide = { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.sizeTableHeaderToFit()
            self?.tableView.endUpdates()
        }
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
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.sizeTableHeaderToFit()
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }

    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }

    private func cellController(forRowAt indexPath: IndexPath) -> CharacterCellController {
        return tableModel[indexPath.row]
    }

    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }

}
