//
//  LogoView.swift
//  tip-calculator
//
//  Created by Omar on 29/09/2023.
//

import Foundation
import UIKit

class LogoView : UIView{
    
    private lazy var imageView:UIImageView = {
        let image : UIImage = #imageLiteral(resourceName: "icCalculatorBW")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let topLabel : UILabel = {
       let label = UILabel()
       let text = NSMutableAttributedString(
        string: "Mr TIP",
        attributes: [.font : ThemeFont.demiBold(ofSize: 16)])
        text.addAttributes([.font : ThemeFont.bold(ofSize: 24)],range: NSMakeRange(3, 3))
        label.attributedText = text
        return label
    }()
    
    private let bottomLabel : UILabel = {
        LabelFactory.build(
            text: "Calculator",
            font: ThemeFont.demiBold(ofSize: 16) ,
            textAlignment: .left)
    }()
    
    private lazy var vStackView : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
        topLabel,
        bottomLabel
        ])
        stack.axis = .vertical
        stack.spacing = -4
        return stack
    }()
    
    private lazy var hStackView : UIStackView = {
       let stack = UIStackView(arrangedSubviews: [
       imageView , vStackView
       ])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.accessibilityIdentifier = ScreenIdentifier.LogoView.logoView.rawValue
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        self.addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width)
        }
    }
}
