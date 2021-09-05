//
//  TableViewController.swift
//  Reciplease
//
//  Created by Birkyboy on 05/09/2021.
//

import UIKit

class RecipeTableViewController: UITableViewController {

    // MARK: - Properties
    private let cellIndentifier = RecipeTableViewCell.identifier

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = "Reciplease"
        configureTableView()
        configureSearchController()
    }

    // MARK: - Setup
    private func configureTableView() {
        self.tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: cellIndentifier)
        self.tableView.rowHeight = 150
    }

    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search recipe"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }

    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: cellIndentifier,
                for: indexPath
        ) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .red
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
// MARK: - Searchc result updater
extension RecipeTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

    }
}
