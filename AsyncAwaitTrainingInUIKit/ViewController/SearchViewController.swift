//
//  SearchViewController.swift
//  AsyncAwaitTrainingInUIKit
//
//  Created by sasaki.ken on 2021/11/28.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private var searchRepository: SearchRepositoryInterface
    private var indicator = UIActivityIndicatorView()
    private var items: [Item] = []
    
    init(searchRepository: SearchRepositoryInterface) {
        self.searchRepository = searchRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.searchRepository = RepositoryLocator.getSearchRepository()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        setUpTableView()
        setUpIndicator()
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpIndicator() {
        indicator.center = view.center
        indicator.style = .large
        indicator.color = .lightGray
        view.addSubview(indicator)
    }
    
    private func refreshTableView() {
        self.items = []
        tableView.reloadData()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        indicator.startAnimating()
        refreshTableView()
        guard let searchText = searchBar.text else {
            indicator.stopAnimating()
            return
        }
        Task {
            guard let items = try await searchRepository.searchGitHubRepository(searchText: searchText) else {
                indicator.stopAnimating()
                return
            }
            self.items = items
            tableView.reloadData()
            indicator.stopAnimating()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let name = cell.viewWithTag(1) as? UILabel
        name?.text = items[indexPath.row].full_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

