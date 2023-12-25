//
//  ThemeFont.swift
//  tip-calculator
//
//  Created by Omar on 30/09/2023.
//

import Foundation
import UIKit

struct ThemeFont{
    static func regular(ofSize size : CGFloat) -> UIFont{
        return UIFont(name: "AvenirNext-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bold(ofSize size : CGFloat) -> UIFont{
        return UIFont(name: "AvenirNext-Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func demiBold(ofSize size : CGFloat) -> UIFont{
        return UIFont(name: "AvenirNext-DemiBold", size: size) ?? .systemFont(ofSize: size)
    }
}
