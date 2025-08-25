//
//  CharactersListViewController.swift
//  RickAndMortyApp
//
//  Created by Serhii Demianenko on 25.08.2025.
//

import UIKit

import UIKit

final class CharactersListViewController: UIViewController {

    private let viewModel = CharactersViewModel()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = 88
        tv.dataSource = self
        tv.delegate = self
        tv.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseID)
        return tv
    }()

    private lazy var spinner: UIActivityIndicatorView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.hidesWhenStopped = true
        return $0
    }(UIActivityIndicatorView(style: .medium))

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Characters"
        view.backgroundColor = .systemBackground
        
        setupUI()
        subscribeOnViewModelEvent()
        viewModel.didLoad()
    }
    
    private func subscribeOnViewModelEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
                case .didLoadData:
                    self.tableView.reloadData()
                case .didShowError(let errorText):
                    self.showError(errorText)
                case .isLoading(let isLoading):
                    isLoading ? self.spinner.startAnimating() : self.spinner.stopAnimating()
            }
        }
    }
    
    private func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @MainActor
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CharactersListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.item(at: indexPath.row) else { return UITableViewCell() }
        
        let cell: CharacterTableViewCell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseID, for: indexPath) as! CharacterTableViewCell
        cell.configure(with: model)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        viewModel.willDisplayCell(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = viewModel.item(at: indexPath.row) else { return }
        
        let detailVC = CharacterDetailViewController(characterID: model.id)
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
