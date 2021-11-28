//
//  SearchRepositoryDataStore.swift
//  AsyncAwaitTrainingInUIKit
//
//  Created by sasaki.ken on 2021/11/28.
//

import Foundation

class SearchRepositoryDataStore {
    private let baseUrl = "https://api.github.com/"
    private let decoder = JSONDecoder()
    
    func searchRepositories(query: String) async throws -> SearchResponseModel? {
        let urlString = baseUrl + "search/repositories?q=\(query)"
        guard let url = URL(string: urlString) else {
            return nil
        }
        let request = URLRequest(url: url)
        async let (data, _) = URLSession.shared.data(for: request)
        let response = try await decoder.decode(SearchResponseModel.self, from: data)
        print("response:",response)
        return response
    }
}
