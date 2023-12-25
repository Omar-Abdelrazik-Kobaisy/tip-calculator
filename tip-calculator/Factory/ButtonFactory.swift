//
//  ButtonFactory.swift
//  tip-calculator
//
//  Created by Omar on 02/10/2023.
//

import Foundation
import UIKit


enum Tip{
    case none
    case tenPercent
    case fifteenPercent
    case twentyPercent
    case plus
    case minus
    case custome(value : Int)
}

extension Tip{
    var stringValue : String {
        switch self {
        case .none:
            return ""
        case .tenPercent:
            return "10%"
        case .fifteenPercent:
            return "15%"
        case .twentyPercent:
            return "20%"
        case .plus:
            return "+"
        case .minus:
            return "-"
        case .custome(value: let value):
            return String(value)
        }
    }
}


struct ButtonFactory {
    static func build(
        with tip : Tip ,
        corners : CACornerMask = [.layerMaxXMaxYCorner,
                                  .layerMaxXMinYCorner,
                                  .layerMinXMaxYCorner,
                                  .layerMinXMinYCorner]) -> UIButton{
        let button = UIButton(type: .custom)
        let text = NSMutableAttributedString(
            string: tip.stringValue,
            attributes: [
                .font : ThemeFont.bold(ofSize: 20),
                .foregroundColor : UIColor.white
            ])
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.cornerRadius(radius: 8.0,corners: corners)
        button.setAttributedTitle(text, for: .normal)
        return button
    }
}
