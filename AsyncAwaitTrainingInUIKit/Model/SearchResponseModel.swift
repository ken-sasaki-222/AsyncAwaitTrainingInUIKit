//
//  SearchResponseModel.swift
//  AsyncAwaitTrainingInUIKit
//
//  Created by sasaki.ken on 2021/11/28.
//

import Foundation

struct SearchResponseModel: Decodable {
    var items: [Item]
}

struct Item: Decodable {
    var name: String
    var full_name: String
    var description: String?
}
