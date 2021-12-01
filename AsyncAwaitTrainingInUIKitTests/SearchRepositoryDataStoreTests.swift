//
//  SearchRepositoryDataStoreTests.swift
//  AsyncAwaitTrainingInUIKitTests
//
//  Created by sasaki.ken on 2021/11/30.
//

import XCTest

class SearchRepositoryDataStoreTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_searchRepositoryDataStore() async throws {
        let dataStore = SearchRepositoryDataStore()
        let searchText = "Swift"
        let response = try await dataStore.searchRepositories(query: searchText)
        let items = response.items
        print("Success search repository dataStore.")
        print("items:", items)
        XCTAssert(items.count > 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
