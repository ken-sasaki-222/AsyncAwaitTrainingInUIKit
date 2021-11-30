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
    
    private func showSearchTextIsEmptyAlert() {
        let alert = UIAlertController(title: "確認", message: "リポジトリ名を入力してください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "やり直す", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showSearchResponseErrorAlert() {
        let alert = UIAlertController(title: "エラー", message: "検索に失敗しました", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "やり直す", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tapRefreshButton(_ sender: UIBarButtonItem) {
        refreshTableView()
        searchBar.text = ""
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
        
        if let searchText = searchBar.text {
            if searchText == "" {
                showSearchTextIsEmptyAlert()
                indicator.stopAnimating()
            } else {
                Task {
                    do {
                        var items = try await searchRepository.searchGitHubRepository(searchText: searchText)
                        print("items:", items as Any)
                        
                        if items.count == 0 {
                            let emptyItem = Item(full_name: "検索結果0件", description: "")
                            items.append(emptyItem)
                            self.items = items
                            tableView.reloadData()
                            indicator.stopAnimating()
                        } else {
                            self.items = items
                            tableView.reloadData()
                            indicator.stopAnimating()
                        }
                    }
                    catch(let error) {
                        print("error:", error.localizedDescription)
                        indicator.stopAnimating()
                        showSearchResponseErrorAlert()
                    }
                }
            }
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
        let description = cell.viewWithTag(2) as? UILabel
        name?.text = items[indexPath.row].full_name
        if description?.text != "" {
            description?.text = items[indexPath.row].description
        } else {
            description?.text = "not description text."
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

