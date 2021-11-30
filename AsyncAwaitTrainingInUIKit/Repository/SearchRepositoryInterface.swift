//
//  SearchRepositoryInterface.swift
//  AsyncAwaitTrainingInUIKit
//
//  Created by sasaki.ken on 2021/11/28.
//

import Foundation

protocol SearchRepositoryInterface {
    func searchGitHubRepository(searchText: String) async throws -> [Item]
}
