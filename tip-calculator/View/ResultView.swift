//
//  ResultView.swift
//  tip-calculator
//
//  Created by Omar on 29/09/2023.
//

import Foundation
import UIKit

class ResultView : UIView{
    private let headerLabel : UILabel = {
        LabelFactory.build(text: "Total p/person", font: ThemeFont.demiBold(ofSize: 16))
    }()
    
    private let priceView : UILabel = {
        let label = UILabel()
        let text = NSMutableAttributedString(
            string: "$000",
            attributes: [.font : ThemeFont.bold(ofSize: 48)] )
        text.addAttributes([.font : ThemeFont.bold(ofSize: 24)], range: NSMakeRange(0, 1))
        label.attributedText = text
        label.textAlignment = .center
        label.accessibilityIdentifier = ScreenIdentifier.ResultView.totalAmountPerPersonValueLabel.rawValue
        return label
    }()
    
    private let horizontalLineView : UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.separator
        return view
    }()
    
    private lazy var vStackView : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
        headerLabel,
        priceView,
        horizontalLineView,
        hStackView
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.backgroundColor = .white
        return stack
    }()
    
    private let totalBill : AmountView  = {
        AmountView(title: "Total bill", alignment: .left, identifier: ScreenIdentifier.ResultView.totalBillValueLabel.rawValue)
    }()
    
    private let totalTip : AmountView = {
        AmountView(title: "Total tip", alignment: .right, identifier: ScreenIdentifier.ResultView.totalTipValueLabel.rawValue)
    }()
    
    private lazy var hStackView : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            totalBill,
            totalTip
        ])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        self.backgroundColor = .white
        self.addShadow(offset: CGSize(width: 0, height: 3), color: .black, radius: 12, opacity: 0.2)
        self.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(24)
            make.bottom.equalTo(self.snp.bottom).offset(-24)
            make.leading.equalTo(self.snp.leading).offset(24)
            make.trailing.equalTo(self.snp.trailing).offset(-24)
        }
        horizontalLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
    }
    func configure(result : Result){
        let text = NSMutableAttributedString(
            string: String(format: "$%.02f", result.amountPerPerson),
            attributes: [.font : ThemeFont.bold(ofSize: 48)] )
        text.addAttributes([.font : ThemeFont.bold(ofSize: 24)], range: NSMakeRange(0, 1))
        priceView.attributedText = text
        totalBill.configure(price: result.totalBill)
        totalTip.configure(price: result.totalTip)
    }
    
}


class AmountView : UIView{
    private let title : String
    private let alignment : NSTextAlignment
    private let identifier : String
    
    private lazy var headerLabel : UILabel = {
        LabelFactory.build(text: title, font: ThemeFont.regular(ofSize: 18),textColor: ThemeColor.text,textAlignment: alignment)
    }()
    
    private lazy var priceView : UILabel = {
        let label = UILabel()
        let text = NSMutableAttributedString(
            string: "$000",
            attributes: [.font : ThemeFont.bold(ofSize: 24)])
        text.addAttributes([.font : ThemeFont.bold(ofSize: 12)], range: NSMakeRange(0, 1))
        label.attributedText = text
        label.textAlignment = alignment
        label.textColor = ThemeColor.primary
        label.accessibilityIdentifier = identifier
        return label
    }()
    
    private lazy var vStackView : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            headerLabel,
            priceView
        ])
        stack.axis = .vertical
        stack.spacing = 3
        return stack
    }()
    init(title : String , alignment : NSTextAlignment , identifier : String){
        self.title = title
        self.alignment = alignment
        self.identifier = identifier
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        self.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func configure(price : Double){
        let text = NSMutableAttributedString(
            string:
                String(format: "$%.02f", price),
            attributes: [.font : ThemeFont.bold(ofSize: 24)])
        text.addAttributes([.font : ThemeFont.bold(ofSize: 12)], range: NSMakeRange(0, 1))
        priceView.attributedText = text
    }
}
