//
//  tip_calculatorUITests.swift
//  tip-calculatorUITests
//
//  Created by Omar on 29/09/2023.
//

import XCTest

final class tip_calculatorUITests: XCTestCase {

    private var app : XCUIApplication!
    
    private var screen : CalculatorScreen {
        CalculatorScreen(app: app)
    }
    
    override func setUp() {
        super.setUp()
        app = .init()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
    
    func testResultViewDefaultValues(){
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$000")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$000")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$000")
    }
    
    func testRegulrTip(){
        screen.enterBill(amount: 100)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$100.00")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$100.00")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0.00")
        screen.doubleTapLogoView()
        screen.enterBill(amount: 120)
        screen.selectTip(tip: .twentyPercent)
        screen.selectIncrementButton(numberOfTaps: 1)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$72.00")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$144.00")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$24.00")
        screen.doubleTapLogoView()
        screen.enterBill(amount: 180)
        screen.selectTip(tip: .customeTip(value: 20))
        screen.selectIncrementButton(numberOfTaps: 3)
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$50.00")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$200.00")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$20.00")
    }
}
