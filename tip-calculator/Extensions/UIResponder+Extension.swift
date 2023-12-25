//
//  UIResponder+Extension.swift
//  tip-calculator
//
//  Created by Omar on 05/10/2023.
//

import Foundation
import UIKit

extension UIResponder{
    func responderChain() ->String {
    guard let next = next else {
    return String(describing: self)
    }
    return String(describing: self) + "->" + next.responderChain()
    }
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
