//
//  challengeTests.swift
//  challengeTests
//
//  Created by JP Montoya on 20.12.22.
//

import Foundation
import SwiftUI
import XCTest
@testable import challenge

final class challengeTests: XCTestCase {
    
    let apiModel = ApiServiceModel()
    
    func test_get_data() {
        //XCTFail()
        
        XCTAssertNoThrow(apiModel.get_data(with_url: URL(string: "https://api.themoviedb.org/3/tv/popular?api_key=91b79e1c018c1a145c60282db74f86e7&language=en-US&page=1")!))
        
    }

    func test_get_nextpage() {
        //XCTFail()
        if let url = Bundle.main.url(forResource: "popularShowList", withExtension: "json") {

                    
            XCTAssertNoThrow(apiModel.get_next_page(with_url: url),"yyyesss")

        }

    }
    
    func test_shouldLoadNextPage(){
        
        apiModel.response = Show_list_response(page: 1, results: [Show(id: 1, title: "Pitufo", vote: 5.5, sinopsis: "Papa pitufo consuma su plan de dominacion", releaseDate: "2022-12-10", image: "/pitufo.png", posterPath: nil)])
        
        XCTAssertFalse(apiModel.shouldLoadNextPage(id:0))
        XCTAssertTrue(apiModel.shouldLoadNextPage(id:1))
    }
}
