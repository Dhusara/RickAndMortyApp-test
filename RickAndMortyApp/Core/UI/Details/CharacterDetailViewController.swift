//
//  CharacterDetailViewController.swift
//  RickAndMortyApp
//
//  Created by Serhii Demianenko on 25.08.2025.
//

import UIKit

final class CharacterDetailViewController: UIViewController {
    
    private let viewModel: CharacterDetailViewModel
    
    private lazy var scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIScrollView())
    
    private lazy var mainStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 16
        $0.layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
        return $0
    }(UIStackView())
    
    private lazy var imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        return $0
    }(UIImageView())
    
    private lazy var stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 8
        return $0
    }(UIStackView())
    
    private lazy var spinner: UIActivityIndicatorView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.hidesWhenStopped = true
        return $0
    }(UIActivityIndicatorView(style: .large))
    
    init(characterID: Int) {
        self.viewModel = CharacterDetailViewModel(id: characterID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Details"
        
        setupUI()
        subscribeOnViewModelEvent()
        viewModel.viewDidLoad()
    }

    private func setupUI() {
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(stackView)
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: 240)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
    }

    private func subscribeOnViewModelEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
                case .didLoadData:
                    updateUI()
                case .didShowError(let errorText):
                    self.showError(errorText)
                case .isLoading(let isLoading):
                    isLoading ? self.spinner.startAnimating() : self.spinner.stopAnimating()
            }
        }
    }
    
    private func updateUI() {
        guard let character = viewModel.character else { return }
        title = character.name
        ImageLoader.shared.setImage(url: URL(string: character.image), into: self.imageView)
        reloadFields(with: character)
    }

    private func reloadFields(with character: CharacterModel) {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        addRow("Status", character.status)
        addRow("Species", character.species)
        addRow("Type", character.type.isEmpty ? "—" : character.type)
        addRow("Gender", character.gender)
        addRow("Origin", character.origin.name)
        addRow("Location", character.location.name)
    }

    private func addRow(_ title: String, _ value: String) {
        let titleLabel = UILabel()
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = .secondaryLabel
        titleLabel.text = title

        let valueLabel = UILabel()
        valueLabel.font = .preferredFont(forTextStyle: .body)
        valueLabel.numberOfLines = 0
        valueLabel.text = value

        let verticalStackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 2
        stackView.addArrangedSubview(verticalStackView)
    }

    @MainActor
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
