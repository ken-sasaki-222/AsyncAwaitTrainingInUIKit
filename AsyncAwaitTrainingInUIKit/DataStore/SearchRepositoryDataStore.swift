//
//  SearchRepositoryDataStore.swift
//  AsyncAwaitTrainingInUIKit
//
//  Created by sasaki.ken on 2021/11/28.
//

import Foundation

class SearchRepositoryDataStore {
    private let baseUrl = "https://api.github.com/"
    private let shared = URLSession.shared
    private let decoder = JSONDecoder()
    
    func searchRepositories(query: String) async throws -> SearchResponseModel {
        let queryString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlString = baseUrl + "search/repositories?q=\(queryString ?? "")"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "error", code: -1, userInfo: nil)
        }
        let request = URLRequest(url: url)
        let (data, _) = try await shared.data(for: request)
        let response = try decoder.decode(SearchResponseModel.self, from: data)
        return response
    }
}
