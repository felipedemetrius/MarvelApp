//
//  CharacterCellController.swift
//  MarveliOSUiKit
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import UIKit
import Combine

final class CharacterCellController {
    private var bag = Set<AnyCancellable>()
    private let viewModel: CharacterViewModel<UIImage>
    private var cell: CharacterCell?

    init(viewModel: CharacterViewModel<UIImage>) {
        self.viewModel = viewModel
    }

    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = binded(tableView.dequeueReusableCell())
        viewModel.loadImageData()
        return cell
    }

    func preload() {
        viewModel.loadImageData()
    }

    func cancelLoad() {
        releaseCellForReuse()
        viewModel.cancelImageDataLoad()
    }

    private func binded(_ cell: CharacterCell) -> CharacterCell {
        self.cell = cell

        cell.name.text = viewModel.name
        cell.descriptionChar.text = viewModel.description
        cell.onRetry = viewModel.loadImageData

        viewModel.onImageLoad.sink { [weak self] image in
            self?.cell?.imageChar.setImageAnimated(image)
        }.store(in: &bag)

        viewModel.onImageLoadingStateChange.sink { [weak self] isLoading in
            self?.cell?.imageContainer.isShimmering = isLoading
        }.store(in: &bag)
        
        viewModel.onShouldRetryImageLoadStateChange.sink { [weak self] shouldRetry in
            self?.cell?.retryButton.isHidden = !shouldRetry
        }.store(in: &bag)
        
        return cell
    }

    private func releaseCellForReuse() {
        bag.forEach { $0.cancel() }
        bag.removeAll()
        cell = nil
    }
}
