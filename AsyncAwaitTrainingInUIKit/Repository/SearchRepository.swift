//
//  SearchRepository.swift
//  AsyncAwaitTrainingInUIKit
//
//  Created by sasaki.ken on 2021/11/28.
//

import Foundation

class SearchRepository: SearchRepositoryInterface {
    private let searchRepositoryDataStore = SearchRepositoryDataStore()
    
    func searchGitHubRepository(searchText: String) async throws -> [Item]? {
        if searchText.isEmpty {
            return nil
        }
        do {
            let response = try await searchRepositoryDataStore.searchRepositories(query: searchText)
            let items = response?.items
            return items
        }
    }
}
