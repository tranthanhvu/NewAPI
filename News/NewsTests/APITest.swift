//
//  APITest.swift
//  NewsTests
//
//  Created by Yoyo on 3/18/21.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import News

class APITest: XCTestCase {

    let total = 56
    
    let stringValues = [
        "e": ""
    ]
    
    let validations: [String: Int] = [
        "l1": 20,
        "l2": 40,
        "f": 56
    ]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPaging() throws {
        let scheduler = TestScheduler(initialClock: 0, resolution: resolution, simulateProcessingDelay: false)

        let (
            loadData,
            reloadData,
            loadMore,
            expectedCells
        ) = (
            scheduler.parseEventsAndTimes(timeline: "e----------------------", values: stringValues).first!,
            scheduler.parseEventsAndTimes(timeline: "----e---------------e--", values: stringValues).first!,
            scheduler.parseEventsAndTimes(timeline: "--------e---e---e------", values: stringValues).first!,
            scheduler.parseEventsAndTimes(timeline: "l1--l1--l2--f-------l1-", values: validations).first!
        )

        let mockAPI = MockNewsAPI(totalItems: total)

        let viewModel = MockViewModel(newsAPI: mockAPI)
        
        let input = MockViewModel.Input(
            loadTrigger: scheduler.createHotObservable(loadData).asDriverOnErrorJustComplete().mapToVoid(),
            reloadTrigger: scheduler.createHotObservable(reloadData).asDriverOnErrorJustComplete().mapToVoid(),
            loadMoreTrigger: scheduler.createHotObservable(loadMore).asDriverOnErrorJustComplete().mapToVoid()
        )
        
        let output = viewModel.transform(input)

        let recorded = scheduler.record(source: output.items.map({ $0.count }).debug("aaa"))

        scheduler.start()
        
        XCTAssertEqual(recorded.events, expectedCells)
    }
}
