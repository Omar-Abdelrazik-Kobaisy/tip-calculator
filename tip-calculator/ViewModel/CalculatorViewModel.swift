//
//  CalculatorViewModel.swift
//  tip-calculator
//
//  Created by Omar on 04/10/2023.
//

import Foundation
import Combine


class CalculatorViewModel {
    private var cancellables = Set<AnyCancellable>()
    struct Input {
        let billPublisher : AnyPublisher<Double , Never>
        let tipPublisher : AnyPublisher<Tip , Never>
        let splitPublisher : AnyPublisher<Int , Never>
        let logoViewTapPublisher : AnyPublisher<Void , Never>
    }
    
    struct Output{
        let updateViewPublisher : AnyPublisher<Result,Never>
        let resetViewFormPublisher :AnyPublisher<Void,Never>
    }
    
    private let audioPlayerService : AudioPlayerService
    init(audioPlayerService : AudioPlayerService = DefaultAudioPlayer()){
        self.audioPlayerService = audioPlayerService
    }
    func transform(input : Input) ->Output{
        let updateViewPublisher = Publishers.CombineLatest3(
            input.billPublisher,
            input.tipPublisher,
            input.splitPublisher).flatMap { [unowned self](bill , tip , split) in
                let totalTip = getTipAmmount(bill: bill, tip: tip)
                let totalbill = bill + totalTip
                let amountPerPerson =  totalbill / Double(split)
                let result = Result(amountPerPerson: amountPerPerson,
                                    totalBill: totalbill,
                                    totalTip: totalTip)
                return Just(result)
            }.eraseToAnyPublisher()
        
        let resetViewFormPublisher =
        input
            .logoViewTapPublisher
            .handleEvents(receiveOutput:  {[unowned self]_ in
            audioPlayerService.playSound()
            }).flatMap { 
                Just(())
            }.eraseToAnyPublisher()
        return Output(updateViewPublisher:updateViewPublisher, resetViewFormPublisher: resetViewFormPublisher)
    }
    
    private func getTipAmmount(bill : Double , tip : Tip) -> Double{
        switch tip {
        case .none , .plus , .minus:
            return 0
        case .tenPercent:
            return bill*0.1
        case .fifteenPercent:
            return bill*0.15
        case .twentyPercent:
            return bill*0.20
        case .custome(let value):
            return Double(value)
        }
    }
}
