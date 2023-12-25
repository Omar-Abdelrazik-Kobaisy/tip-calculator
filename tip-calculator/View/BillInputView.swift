//
//  BillInputView.swift
//  tip-calculator
//
//  Created by Omar on 29/09/2023.
//

import Foundation
import UIKit
import Combine
import CombineCocoa

class BillInputView : UIView{
    
    private let headerView : HeaderView = {
        let view = HeaderView()
        view.configure(topString: "Enter", bottomString: "your bill")
        return view
    }()
    
    private let textContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerRadius(radius: 8)
        return view
    }()
    
    private let dollarSign : UILabel = {
        let label = LabelFactory.build(text: "$", font: ThemeFont.bold(ofSize: 24))
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var textField : UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = ThemeFont.demiBold(ofSize: 28)
        textField.keyboardType = .decimalPad
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.tintColor = ThemeColor.text
        textField.textColor = ThemeColor.text
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 36))
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: self, action: #selector(didPressDoneButton))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                            target: nil,
                            action: nil),
            doneButton
        ]
        toolbar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolbar
        textField.accessibilityIdentifier = ScreenIdentifier.BillInputView.textField.rawValue
        return textField
    }()
    private let billSubject : PassthroughSubject<Double , Never> = .init()
    var billPublisher : AnyPublisher<Double , Never> {
        return billSubject.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func observe(){
        textField.textPublisher.sink { [weak self] text in
            self?.billSubject.send(Double(text ?? "") ?? 0)
        }.store(in: &cancellables)
    }
    
    private func layout(){
        
        [headerView, textContainerView].forEach(addSubview(_:))
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(textContainerView.snp.centerY)
//            make.trailing.equalTo(textContainerView.snp.leading).offset(-10)
            make.width.equalTo(65)
            make.height.equalToSuperview()
        }
        
        textContainerView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(headerView.snp.trailing).offset(15)
        }
        
        [dollarSign , textField].forEach(textContainerView.addSubview(_:))
        
        dollarSign.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(textContainerView.snp.leading).offset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(dollarSign.snp.trailing).offset(16)
            make.trailing.equalTo(textContainerView.snp.trailing).offset(-16)
        }
    }
    
    @objc private func didPressDoneButton(){
        textField.endEditing(true)
    }
    
    func reset(){
        textField.text = nil
        billSubject.send(0)
    }
    
    func text() ->String?{
        textField.text
    }
}
