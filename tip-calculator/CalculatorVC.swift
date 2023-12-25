//
//  ViewController.swift
//  tip-calculator
//
//  Created by Omar on 29/09/2023.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
//protocol views {
//    var logoView : LogoView { get }
//    var resultView : ResultView {get}
//    var billInputView : BillInputView {get}
//    var tipInputView : TipInputView {get}
//    var splitInputView : SplitInputView {get}
//}
class CalculatorVC: UIViewController {
//    private(set) var logoView: LogoView = {
//         LogoView()
//    }()
//
//    private(set) var resultView: ResultView = {
//         ResultView()
//    }()
//
//    private(set) var billInputView: BillInputView = {
//        BillInputView()
//    }()
//
//    private(set) var tipInputView: TipInputView = {
//        TipInputView()
//    }()
//
//    private(set) var splitInputView: SplitInputView = {
//        SplitInputView()
//    }()
    

    
    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    private let vm = CalculatorViewModel()
    private var cancellabels = Set<AnyCancellable>()
    
    private lazy var viewTapPubliser : AnyPublisher<Void , Never> = {
       let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    private lazy var logoViewTapPubliser : AnyPublisher<Void , Never> = {
       let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 2
        logoView.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    private lazy var vStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            logoView,
            resultView,
            billInputView,
            tipInputView,
            splitInputView,
            UIView()
        ])
        stack.axis = .vertical
        stack.spacing = 35
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
        observe()
    }

    private func bind(){
        let input = CalculatorViewModel.Input(
            billPublisher: billInputView.billPublisher,
            tipPublisher: tipInputView.tipPublisher,
            splitPublisher: splitInputView.splitPublisher,
            logoViewTapPublisher: logoViewTapPubliser)
        
        let output = vm.transform(input: input)
        
        output.updateViewPublisher.sink { [weak self] result in
            self?.resultView.configure(result: result)
        }.store(in: &cancellabels)
        
        output.resetViewFormPublisher.sink {[unowned self] _ in
            billInputView.reset()
            tipInputView.reset()
            splitInputView.reset()
            
            UIView.animate(
                withDuration: 0.15,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0.5, animations: {
                    self.logoView.transform = .init(scaleX: 0.5, y: 2.5)
                }) { _ in
                    UIView.animate(withDuration: 0.15) {
                        self.logoView.transform = .identity
                    }
                }
        }.store(in: &cancellabels)
    }
    
    private func observe(){
        viewTapPubliser.sink {[unowned self] _ in
            view.endEditing(true)
        }.store(in: &cancellabels)
    }
    
    private func layout(){
        view.addSubview(vStack)
        view.backgroundColor = ThemeColor.bg
        vStack.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            make.top.equalTo(view.snp.topMargin).offset(16)
        }
        
        logoView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        resultView.snp.makeConstraints { make in
            make.height.equalTo(224)
        }
        billInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        tipInputView.snp.makeConstraints { make in
            make.height.equalTo(56+56+16)
        }
        splitInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        
    }

}

