//
//  GeneratePasswordViewModelTests.swift
//  NubankPrepTests
//
//  Created by Gabriel Araujo on 21/09/19.
//  Copyright © 2019 Gabriel Araujo. All rights reserved.
//

import XCTest
import RxSwift
import RxSwiftExt
import RxTest
import Moya

@testable import NubankPrep

class GeneratePasswordViewModelTests: XCTestCase {
    
    var testScheduler: TestScheduler!
    var bag = DisposeBag()
    

    override func setUp() {
        super.setUp()
        testScheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        super.tearDown()
        bag = DisposeBag()
        testScheduler = nil
    }
    
    func testSelectedLength() {
        let sliderEvents = [
            Recorded.next(100, Float(6)),
            Recorded.next(200, Float(20)),
            Recorded.next(300, Float(30))
        ]
        
        let sliderObs = testScheduler.createHotObservable(sliderEvents)
        
        let length = PublishSubject<Float>()
        let uppercase = PublishSubject<Bool>()
        let digits = PublishSubject<Bool>()
        let special = PublishSubject<Bool>()
        let buttonGenerate = PublishSubject<Void>()
        
        let viewModel = GeneratePasswordViewModel(passwordLength: length, selectedUppercase: uppercase, selectedContainsDigits: digits, selectedSpecialCharacters: special, tappedGenerate: buttonGenerate)
        
        let res = testScheduler.createObserver(Int.self)
        viewModel.selectedLength
            .drive(res)
            .disposed(by: bag)
        
        sliderObs.bind(to: length)
            .disposed(by: bag)
        testScheduler.start()
        
        let expectedEvents = [
            Recorded.next(100, 6),
            Recorded.next(200, 20),
            Recorded.next(300, 30)
        ]
        
        XCTAssertEqual(res.events, expectedEvents)
    }
    
    func testGeneratePassword() {
        
        let length = BehaviorSubject<Float>(value: Float(8))
        let uppercase = BehaviorSubject<Bool>(value: true)
        let digits = BehaviorSubject<Bool>(value: true)
        let special = BehaviorSubject<Bool>(value: true)
        
        let buttonEvent = [Recorded.next(200, ())]
        let buttonTapObs = testScheduler.createHotObservable(buttonEvent)
        let buttonGenerate = PublishSubject<Void>()
        
        let provider = MoyaProvider<APIConfig>(stubClosure: MoyaProvider.immediatelyStub)
        let repository = GeneratePasswordAPIRepository(provider: provider)
        
        let viewModel = GeneratePasswordViewModel(passwordLength: length, selectedUppercase: uppercase, selectedContainsDigits: digits, selectedSpecialCharacters: special, tappedGenerate: buttonGenerate, repository: repository)
        
        let res = testScheduler.createObserver(GeneratePasswordState.self)
        viewModel.state
            .drive(res)
            .disposed(by: bag)
        
        buttonTapObs.bind(to: buttonGenerate).disposed(by: bag)
        
        testScheduler.start()
        
        let expectedEvent = Recorded.next(200, GeneratePasswordState.generated(password: "123456Aa"))
        
        XCTAssertTrue(res.events.contains(expectedEvent))
    }
    
    func testErrorGeneratingPassword() {
        
        let length = BehaviorSubject<Float>(value: Float(8))
        let uppercase = BehaviorSubject<Bool>(value: true)
        let digits = BehaviorSubject<Bool>(value: true)
        let special = BehaviorSubject<Bool>(value: true)
        
        let buttonEvent = [Recorded.next(200, ())]
        let buttonTapObs = testScheduler.createHotObservable(buttonEvent)
        let buttonGenerate = PublishSubject<Void>()
        
        let closure = { (target: APIConfig) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(400 , Data()) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        let provider = MoyaProvider<APIConfig>(endpointClosure: closure, stubClosure: MoyaProvider.immediatelyStub)
        let repository = GeneratePasswordAPIRepository(provider: provider)
        
        let viewModel = GeneratePasswordViewModel(passwordLength: length, selectedUppercase: uppercase, selectedContainsDigits: digits, selectedSpecialCharacters: special, tappedGenerate: buttonGenerate, repository: repository)
        
        let res = testScheduler.createObserver(GeneratePasswordState.self)
        viewModel.state
            .debug()
            .drive(res)
            .disposed(by: bag)
        
        buttonTapObs.bind(to: buttonGenerate).disposed(by: bag)
        
        testScheduler.start()
        let err = MoyaError.statusCode(Response(statusCode: 400, data: Data()))
        let expectedEvent = Recorded.next(200, GeneratePasswordState.error(error: err))
        
        XCTAssertTrue(res.events.contains(expectedEvent))
    }

}
