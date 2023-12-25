//
//  UIView+Extension.swift
//  tip-calculator
//
//  Created by Omar on 01/10/2023.
//

import Foundation
import UIKit

extension UIView {
    func addShadow(offset :CGSize,
                   color : UIColor,
                   radius : CGFloat,
                   opacity:Float){
        layer.cornerRadius = radius
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    func cornerRadius(
        radius : CGFloat ,
        corners : CACornerMask =
        [.layerMaxXMaxYCorner,
         .layerMaxXMinYCorner,
         .layerMinXMaxYCorner,
         .layerMinXMinYCorner]){
        layer.cornerRadius = radius
        layer.maskedCorners = [corners]
        layer.masksToBounds = false
    }
}

extension UIView {

    /** This is the function to get subViews of a view of a particular type
*/
    func subViews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }


/** This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T */
        func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
            var all = [T]()
            func getSubview(view: UIView) {
                if let aView = view as? T{
                all.append(aView)
                }
                guard view.subviews.count>0 else { return }
                view.subviews.forEach{ getSubview(view: $0) }
            }
            getSubview(view: self)
            return all
        }
    }
