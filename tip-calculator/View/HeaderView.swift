//
//  HeaderView.swift
//  tip-calculator
//
//  Created by Omar on 02/10/2023.
//

import Foundation
import UIKit
class HeaderView : UIView{
    private lazy var topLabel : UILabel = {
        LabelFactory.build(text: nil,
                           font: ThemeFont.bold(ofSize: 18))
    }()
    private lazy var bottomLabel : UILabel = {
        LabelFactory.build(text: nil,
                           font: ThemeFont.regular(ofSize: 16))
    }()
    
    private lazy var vStackView : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            topLabel,
            bottomLabel
        ])
        stack.axis = .vertical
        stack.spacing = -20
        stack.alignment = .leading
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
      
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(topString : String , bottomString : String){
        self.topLabel.text = topString
        self.bottomLabel.text = bottomString
    }
    private func layout(){
        self.addSubview(vStackView)
        
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
