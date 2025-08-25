//
//  CharacterTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Serhii Demianenko on 25.08.2025.
//

import UIKit

final class CharacterTableViewCell: UITableViewCell {
    
    static let reuseID: String = "CharacterTableViewCell"
    
    private lazy var mainStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 4
        return $0
    }(UIStackView())
    
    private lazy var labelsStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 8
        return $0
    }(UIStackView())
    
    private lazy var avatarImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        return $0
    }(UIImageView())
    
    private lazy var nameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: .black)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private lazy var metaLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 12)
        $0.numberOfLines = .zero
        return $0
    }(UILabel())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        nameLabel.text = nil
        metaLabel.text = nil
    }
    
    // MARK: Public methods
    
    public func configure(with character: CharacterModel?) {
        guard let character else { return }
        
        nameLabel.text = character.name
        metaLabel.text = "Status: \(character.status) • Gender: \(character.gender) • Origin: \(character.origin.name)"
        ImageLoader.shared.setImage(url: URL(string: character.image), into: avatarImageView)
    }
    
    // MARK: Private methods
    
    private func setupUI() {
        let avatarSize: CGFloat = 64
        
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(avatarImageView)
        mainStackView.addArrangedSubview(labelsStackView)
        labelsStackView.addArrangedSubview(nameLabel)
        labelsStackView.addArrangedSubview(metaLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: avatarSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: avatarSize),
            
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
