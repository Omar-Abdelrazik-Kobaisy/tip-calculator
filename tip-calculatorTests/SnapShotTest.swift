//
//  SnapShotTest.swift
//  tip-calculatorTests
//
//  Created by Omar on 08/10/2023.
//

import XCTest
import SnapshotTesting
@testable import tip_calculator
final class SnapShotTest: XCTestCase {
    
    private var screenWidth : CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    func testLogoView(){
        //given
        let size = CGSize(width: screenWidth, height: 48)
        //when
        let view = LogoView()
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }


    func testInitialResultView(){
        //given
        let size = CGSize(width: screenWidth, height: 224)
        //when
        let view = ResultView()
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }

    func testResultViewWithValue(){
        //given
        let size = CGSize(width: screenWidth, height: 224)
        let result = Result(amountPerPerson: 100.52, totalBill: 200.99, totalTip: 30)
        //when
        let view = ResultView()
        view.configure(result: result)
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }


    func testInitialBillView(){
        //given
        let size = CGSize(width: screenWidth, height: 56)
        //when
        let view = BillInputView()
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }


    func testBillViewWithValue(){
        //given
        let size = CGSize(width: screenWidth, height: 56)
        //when
        let view = BillInputView()
        let textField = view.allSubViewsOf(type: UITextField.self).first
        textField?.text = "100.98765"
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }

    func testInitialTipView(){
        //given
        let size = CGSize(width: screenWidth, height: 56+56+16)
        //when
        let view = TipInputView()
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testTipViewWithValue(){
        //given
        let size = CGSize(width: screenWidth, height: 56+56+16)
        //when
        let view = TipInputView()
        let button = view.allSubViewsOf(type: UIButton.self)[1]
        button.sendActions(for: .touchUpInside)
        //then
        assertSnapshot(matching: view, as: .image(size: size) )
    }

    func testInitialSplitView(){
        //given
        let size = CGSize(width: screenWidth, height: 56)
        //when
        let view = SplitInputView()
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }


     func testSplitViewWithSelection(){
        //given
        let size = CGSize(width: screenWidth, height: 56)
        //when
        let view = SplitInputView()
        let button = view.allSubViewsOf(type: UIButton.self).last
        button?.sendActions(for: .touchUpInside)
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }

}
