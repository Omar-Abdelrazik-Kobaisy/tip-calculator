//
//  SplitInputView.swift
//  tip-calculator
//
//  Created by Omar on 29/09/2023.
//

import Foundation
import UIKit
import Combine
import CombineCocoa
class SplitInputView : UIView{
    
    private let headerView : HeaderView = {
        let view = HeaderView()
        view.configure(topString: "Split", bottomString: "the total")
        return view
    }()
    
    private lazy var incrementButton : UIButton = {
        let button = ButtonFactory.build(
            with: .plus ,
            corners: [
                .layerMaxXMinYCorner,
                .layerMaxXMaxYCorner])
        button.tapPublisher.flatMap { [unowned self] _ in
            Just(splitSubject.value + 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellables)
        button.accessibilityIdentifier = ScreenIdentifier.SplitView.increment.rawValue
        return button
    }()
    
    private lazy var decrementButton : UIButton = {
        let button = ButtonFactory.build(
            with: .minus ,
            corners: [.layerMinXMinYCorner,
                      .layerMinXMaxYCorner])
        button.tapPublisher.flatMap { [unowned self] _ in
            Just(splitSubject.value == 1 ? 1 :splitSubject.value - 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellables)
        button.accessibilityIdentifier = ScreenIdentifier.SplitView.decrement.rawValue
        return button
    }()
    
    private let quantityLabel : UILabel = {
        let label = LabelFactory.build(text: "1", font: ThemeFont.bold(ofSize: 20) , backgroundColor: .white)
        label.accessibilityIdentifier = ScreenIdentifier.SplitView.quantityLabel.rawValue
        return label
    }()
    
    private lazy var hStackView : UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [decrementButton,quantityLabel,incrementButton])
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillEqually
        return stack
    }()
    //MARK: publisher
    private var splitSubject : CurrentValueSubject<Int , Never> = .init(1)
    var splitPublisher : AnyPublisher<Int , Never> {
        return splitSubject.removeDuplicates().eraseToAnyPublisher()
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
    
    private func layout(){
        [headerView , hStackView].forEach(addSubview(_:))
        
        hStackView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(hStackView.snp.height)
            make.width.equalTo(75)
            make.centerY.equalTo(hStackView.snp.centerY)
            make.trailing.equalTo(hStackView.snp.leading).offset(-25)
        }
    }
    
    private func observe(){
        splitSubject.sink {[weak self] quantity in
            self?.quantityLabel.text = String(quantity)
        }.store(in: &cancellables)
    }
    
    func reset(){
        splitSubject.send(1)
    }
}
