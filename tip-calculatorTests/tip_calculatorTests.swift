//
//  tip_calculatorTests.swift
//  tip-calculatorTests
//
//  Created by Omar on 29/09/2023.
//

import XCTest
import Combine
@testable import tip_calculator

final class tip_calculatorTests: XCTestCase {

    private var sut : CalculatorViewModel!
    private var billInputView : BillInputView!
    private var audioPlayerService : MockAudioPlayerService!
    private var cancellables : Set<AnyCancellable>!
    private var logoViewTapPublisher : PassthroughSubject<Void , Never>!
    
    override func setUp() {
        audioPlayerService = .init()
        sut = CalculatorViewModel(audioPlayerService: audioPlayerService)
        billInputView = BillInputView()
        cancellables = .init()
        logoViewTapPublisher = .init()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        billInputView = nil
        cancellables = nil
        logoViewTapPublisher = nil
        audioPlayerService = nil
    }

    // -$100 bill
    // -none tip
    // -1 person
    func testResultWithoutTipForOnePerson(){
        //given
        let bill : Double = 100.0
        let tip : Tip = .none
        let split : Int = 1
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 100)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }
    // -$100 bill
    // -none tip
    // -2 person
    func testResultWithoutTipForTwoPerson(){
        //given
        let bill : Double = 100.0
        let tip : Tip = .none
        let split : Int = 2
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 50)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }
    // -$100 bill
    // -10 percent tip
    // -2 person
    func testResultWithTenPercentTipForTwoPerson(){
        //given
        let bill : Double = 100.0
        let tip : Tip = .tenPercent
        let split : Int = 2
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 55)
            XCTAssertEqual(result.totalBill, 110)
            XCTAssertEqual(result.totalTip, 10)
        }.store(in: &cancellables)
    }
    // -$100 bill
    // -custom Tip
    // -4 person
    func testResultWithCustomTipForFourPerson(){
        //given
        let bill : Double = 100.0
        let tip : Tip = .custome(value: 25)
        let split : Int = 4
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 31.25)
            XCTAssertEqual(result.totalBill, 125)
            XCTAssertEqual(result.totalTip, 25)
        }.store(in: &cancellables)
    }
    func testSoundPLayAndCalculatorResetOnLogoViewTap(){
        //given
        let input = buildInput(bill: 100, tip: .tenPercent, split: 2)
        let output = sut.transform(input: input)
        let expectation = audioPlayerService.expectation
        
        //then
        output.resetViewFormPublisher.sink { [weak self] _ in
            XCTAssertEqual((self?.billInputView.text())!, "")
//            expectation.fulfill()
        }.store(in: &cancellables)
        //when
        logoViewTapPublisher.send()
        wait(for: [expectation], timeout: 2.0)
    }
    private func buildInput(bill : Double ,
                            tip : Tip ,
                            split : Int) -> CalculatorViewModel.Input {
        return .init(
            billPublisher: Just(bill).eraseToAnyPublisher(),
            tipPublisher: Just(tip).eraseToAnyPublisher(),
            splitPublisher: Just(split).eraseToAnyPublisher(),
            logoViewTapPublisher: logoViewTapPublisher.eraseToAnyPublisher())
    }
}
