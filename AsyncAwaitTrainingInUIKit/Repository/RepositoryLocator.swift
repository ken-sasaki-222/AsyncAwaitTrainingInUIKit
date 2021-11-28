//
//  RepositoryLocator.swift
//  AsyncAwaitTrainingInUIKit
//
//  Created by sasaki.ken on 2021/11/28.
//

import Foundation

class RepositoryLocator {
    
    static func getSearchRepository() -> SearchRepositoryInterface {
        return SearchRepository()
    }
}
