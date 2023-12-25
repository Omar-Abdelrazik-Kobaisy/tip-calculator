//
//  MockAudioPlayerService.swift
//  tip-calculatorTests
//
//  Created by Omar on 08/10/2023.
//
@testable import tip_calculator
import XCTest

class MockAudioPlayerService : AudioPlayerService{
    let expectation = XCTestExpectation(description: "playSound called")
    func playSound() {
        expectation.fulfill()
    }
    
    
}
