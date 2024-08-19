//
//  CharacterCell.swift
//  MarveliOSUiKit
//
//  Created by Felipe Demetrius Martins da Silva on 18/08/24.
//

import UIKit

public final class CharacterCell: UITableViewCell {
    var onRetry: (() -> Void)?

    public lazy var imageChar: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.borderWidth = 0.5
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    public lazy var name: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public lazy var descriptionChar: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 4
        label.textAlignment = .natural
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var imageContainer: UIView = {
        let view = UIView()
        view.frame.size.height = 375
        view.frame.size.width = 375
        view.addSubview(imageChar.makeContainer())
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 375),
            view.widthAnchor.constraint(equalToConstant: 375),
        ])
        
        retryButton.setTitle("↻", for: .normal)
        retryButton.addTarget(self, action: #selector(onRetryTouched), for: .touchUpInside)
        retryButton.titleLabel?.font = .boldSystemFont(ofSize: 60)
        retryButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(retryButton.makeContainer())

        return view
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(imageContainer)
        stackView.addArrangedSubview(descriptionChar)
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func onRetryTouched() {
        onRetry?()
    }

    private func setupCell() {
        self.selectionStyle = .none
        self.accessoryType = .none
        addComponents()
        installConstraints()
    }

    private func addComponents() {
        contentView.addSubview(stackView)
        imageChar.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    private func installConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
        ])
    }

}
