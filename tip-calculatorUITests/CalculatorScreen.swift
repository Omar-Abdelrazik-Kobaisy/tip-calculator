//
//  CalculatorScreen.swift
//  tip-calculatorUITests
//
//  Created by Omar on 10/10/2023.
//

import Foundation
import XCTest

class CalculatorScreen {
    private let app : XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
//    MARK: LogoView
    var logoView : XCUIElement {
        app.otherElements[ScreenIdentifier.LogoView.logoView.rawValue]
    }
    //MARK: ResultView
    var totalAmountPerPersonValueLabel : XCUIElement {
        app.staticTexts[ScreenIdentifier.ResultView.totalAmountPerPersonValueLabel.rawValue]
    }
    var totalBillValueLabel : XCUIElement {
        app.staticTexts[ScreenIdentifier.ResultView.totalBillValueLabel.rawValue]
    }
    var totalTipValueLabel : XCUIElement {
        app.staticTexts[ScreenIdentifier.ResultView.totalTipValueLabel.rawValue]
    }
//    MARK: BillInputView
    var billInputViewTextField : XCUIElement {
        app.textFields[ScreenIdentifier.BillInputView.textField.rawValue]
    }
//    MARK: TipInputView
    var tenPercentButton : XCUIElement {
        app.buttons[ScreenIdentifier.TipInputView.tenPercent.rawValue]
    }
    var fifteenPercentButton : XCUIElement {
        app.buttons[ScreenIdentifier.TipInputView.fifteenPercent.rawValue]
    }
    var twentyPercentButton : XCUIElement {
        app.buttons[ScreenIdentifier.TipInputView.twentyPercent.rawValue]
    }
    var customeTipButton : XCUIElement {
        app.buttons[ScreenIdentifier.TipInputView.customeTip.rawValue]
    }
    var alertTextField : XCUIElement{
        app.textFields[ScreenIdentifier.TipInputView.customeTipAlertTextField.rawValue]
    }
//    MARK: SplitInputView
    var plusButton : XCUIElement {
        app.buttons[ScreenIdentifier.SplitView.increment.rawValue]
    }
    var minusButton : XCUIElement {
        app.buttons[ScreenIdentifier.SplitView.decrement.rawValue]
    }
    var quantityLabel : XCUIElement {
        app.staticTexts[ScreenIdentifier.SplitView.quantityLabel.rawValue]
    }
//    MARK: Actios
    func doubleTapLogoView(){
        logoView.doubleTap()
    }
    func enterBill(amount bill:Double){
        billInputViewTextField.tap()
        billInputViewTextField.typeText("\(bill)\n")
    }
    func selectTip(tip:Tip){
        switch tip{
        case .tenPercent:
            tenPercentButton.tap()
        case .fifteenPercent:
            fifteenPercentButton.tap()
        case .twentyPercent:
            twentyPercentButton.tap()
        case .customeTip(let value):
            customeTipButton.tap()
            XCTAssertTrue(alertTextField.waitForExistence(timeout: 1.0))
            alertTextField.typeText("\(value)\n")
        }
    }
    func selectIncrementButton(numberOfTaps : Int){
        plusButton.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: 1)
    }
    func selectdecrementButton(numberOfTaps : Int){
        minusButton.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: 1)
    }
}
enum Tip {
    case tenPercent
    case fifteenPercent
    case twentyPercent
    case customeTip(value:Int)
}
