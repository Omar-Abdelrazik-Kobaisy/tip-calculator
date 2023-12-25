//
//  ScreenIdentifier.swift
//  tip-calculator
//
//  Created by Omar on 10/10/2023.
//

import Foundation

enum ScreenIdentifier {
//    MARK: logoView
    enum LogoView : String {
        case logoView
    }
//    MARK: resultView
    enum ResultView : String{
        case totalAmountPerPersonValueLabel
        case totalBillValueLabel
        case totalTipValueLabel
    }
//    MARK: billView
    enum BillInputView :String{
        case textField
    }
//    MARK: tipView
    enum TipInputView : String {
        case tenPercent
        case fifteenPercent
        case twentyPercent
        case customeTip
        case customeTipAlertTextField
    }
//    MARK: splitView
    enum SplitView : String{
        case increment
        case decrement
        case quantityLabel
    }
}
