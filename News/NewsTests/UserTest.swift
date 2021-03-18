//
//  RegisterUserTest.swift
//  NewsTests
//
//  Created by Yoyo on 3/18/21.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import News

class UserTest: XCTestCase {
    
    let stringValues = [
        "u1" : "yoyo",
        "c1" : Category.apple.rawValue,
        "c2" : Category.bitcoin.rawValue,
        "e" : ""
    ]
    
    let validations: [String: [CellType]] = [
        "e": [],
        "r" : [.register],
        "u1" : [.userInfo("yoyo"), .categoryInfo(AppManager.shared.currentCategory.rawValue), .signOut],
        "u2" : [.userInfo("yoyo"), .categoryInfo(Category.apple.rawValue), .signOut],
        "u3" : [.userInfo("yoyo"), .categoryInfo(Category.bitcoin.rawValue), .signOut]
    ]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        AppManager.shared.start()
        AppManager.shared.signOut()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRegisterAndSignOut() throws {
        let scheduler = TestScheduler(initialClock: 0, resolution: resolution, simulateProcessingDelay: false)

        let (
            registerWithName,
            changeCategory,
            signOut,
            expectedCells
        ) = (
            scheduler.parseEventsAndTimes(timeline: "----u1---------------", values: stringValues).first!,
            scheduler.parseEventsAndTimes(timeline: "---------c1---c2-----", values: stringValues).first!,
            scheduler.parseEventsAndTimes(timeline: "-------------------e-", values: stringValues).first!,
            scheduler.parseEventsAndTimes(timeline: "r---u1---u2---u3---r-", values: validations).first!
        )

        let viewModel = ProfileViewModel()

        let input = ProfileViewModel.Input(
            userInfo: AppManager.shared.userInfo.asDriver(),
            registerWithName: scheduler.createHotObservable(registerWithName).asDriverOnErrorJustComplete(),
            changeCategory: scheduler.createHotObservable(changeCategory).compactMap({ Category(rawValue: $0) }).asDriverOnErrorJustComplete(),
            signOut: scheduler.createHotObservable(signOut).mapToVoid().asDriverOnErrorJustComplete())

        let output = viewModel.transform(input)

        let recorded = scheduler.record(source: output.items.debug("aaa"))
        
        let _ = scheduler.record(source: output.selectedCell)

        scheduler.start()
        
        XCTAssertEqual(recorded.events, expectedCells)
    }
}
