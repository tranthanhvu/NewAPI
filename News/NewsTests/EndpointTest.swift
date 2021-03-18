//
//  EndpointTest.swift
//  NewsTests
//
//  Created by Yoyo on 3/18/21.
//

import XCTest
import News

class EndpointTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHeadlinesURL() throws {
        let headlinesUrl = Endpoint.headlines.getUrl(page: 1)
        XCTAssertNotNil(headlinesUrl)
    }
    
    func testNewsURL() throws {
        let urls = Category.allCases
            .compactMap({ Endpoint.news($0).getUrl(page: 1) })
        
        XCTAssertTrue(urls.count == Category.allCases.count)
    }
    
    func testPageIndex() throws {
        XCTAssertTrue(Endpoint.getNextPage(offset: 0) == 1)
        XCTAssertTrue(Endpoint.getNextPage(offset: Endpoint.pageSize) == 2)
        XCTAssertTrue(Endpoint.getNextPage(offset: Endpoint.pageSize - 1) == nil)
        XCTAssertTrue(Endpoint.getNextPage(offset: Endpoint.pageSize + 1) == nil)
    }
    
    func testLoadEnvironmentIndex() throws {
        let atts = Environment.Keys.allCases
            .compactMap({ Environment.valueOrNil(fromKey: $0) })
        
        XCTAssertTrue(atts.count == Environment.Keys.allCases.count)
    }
}
