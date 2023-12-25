//
//  TipInputView.swift
//  tip-calculator
//
//  Created by Omar on 29/09/2023.
//

import Foundation
import UIKit
import Combine
import CombineCocoa

class TipInputView : UIView{
    
    
    private let headerView : HeaderView = {
        let view = HeaderView()
        view.configure(topString: "Choose",
                       bottomString: "your tip")
        return view
    }()
    
    private lazy var tenPercentButton : UIButton = {
        let button = ButtonFactory.build(with: .tenPercent)
        button.tapPublisher.flatMap {
            Just(Tip.tenPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.tenPercent.rawValue
        return button
    }()
    private lazy var fifteenPercentButton : UIButton = {
        let button = ButtonFactory.build(with: .fifteenPercent)
        button.tapPublisher.flatMap {
            Just(Tip.fifteenPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.fifteenPercent.rawValue
        return button
    }()
    private lazy var twentyPercentButton : UIButton = {
        let button = ButtonFactory.build(with: .twentyPercent)
        button.tapPublisher.flatMap {
            Just(Tip.twentyPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.twentyPercent.rawValue
        return button
    }()
    
    private lazy var customeTipButton : UIButton = {
        let button = UIButton()
        button.setTitle("Custome tip", for: .normal)
        button.backgroundColor = ThemeColor.primary
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.tintColor = .white
        button.cornerRadius(radius: 8)
        button.tapPublisher.sink { [unowned self] _ in
            handleCustomeTipButton()
        }.store(in: &cancellables)
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.customeTip.rawValue
        return button
    }()
    private lazy var hStackView : UIStackView = {
        let stack = UIStackView(
            arrangedSubviews:[tenPercentButton,fifteenPercentButton,twentyPercentButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private lazy var vStackView : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            hStackView,
            customeTipButton
        ])
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private let tipSubject : CurrentValueSubject<Tip , Never> = .init(.none)
    var tipPublisher : AnyPublisher<Tip , Never> {
        return tipSubject.eraseToAnyPublisher()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        [headerView , vStackView].forEach(addSubview(_:))
        
        vStackView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
        }
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(hStackView.snp.height)
            make.width.equalTo(75)
            make.centerY.equalTo(hStackView.snp.centerY)
            make.trailing.equalTo(vStackView.snp.leading).offset(-25)
        }
    }
    private func handleCustomeTipButton(){
        let alertController : UIAlertController = {
            let controller = UIAlertController(
                title: "Enter Custom Tip",
                message: nil,
                preferredStyle: .alert)
            controller.addTextField { textField in
                textField.placeholder = "Make it generous"
                textField.keyboardType = .numberPad
                textField.autocorrectionType = .no
                textField.accessibilityIdentifier = ScreenIdentifier.TipInputView.customeTipAlertTextField.rawValue
            }
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel)
            let oKAction = UIAlertAction(title: "ok",
                                         style: .default) { action in
                guard let text = controller.textFields?.first?.text ,
                      let value = Int(text) else {return}
                self.tipSubject.send(.custome(value: value))
            }
            [oKAction , cancelAction].forEach(controller.addAction(_:))
            return controller
        }()
        parentViewController?.present(alertController, animated: true)
    }
    private func observe(){
        tipSubject.sink {[weak self] tip in
            self?.resetView()
            switch tip{
            case .none , .plus , .minus:
                break
            case .tenPercent:
                self?.tenPercentButton.backgroundColor = ThemeColor.secondary
            case .fifteenPercent:
                self?.fifteenPercentButton.backgroundColor = ThemeColor.secondary
            case .twentyPercent:
                self?.twentyPercentButton.backgroundColor = ThemeColor.secondary
            case .custome(value: let value):
                self?.customeTipButton.backgroundColor = ThemeColor.secondary
                let text = NSMutableAttributedString(string: "$\(value)",attributes: [.font : ThemeFont.bold(ofSize: 20)])
                self?.customeTipButton.setAttributedTitle(text, for: .normal)
            }
        }.store(in: &cancellables)
    }
    private func resetView(){
        [tenPercentButton,
        fifteenPercentButton,
        twentyPercentButton,
         customeTipButton].forEach { button in
            button.backgroundColor = ThemeColor.primary
        }
        let text = NSMutableAttributedString(string: "Custome tip" , attributes: [.font : ThemeFont.bold(ofSize: 20)])
        customeTipButton.setAttributedTitle(text, for: .normal)
    }
    func reset(){
        tipSubject.send(.none)
    }
}

