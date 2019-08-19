//
//  LabelCellView.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class LabelCellView: NSTableCellView {
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var formulaesCountTextField: NSTextField!

    fileprivate var _bag: DisposeBag!
    fileprivate var _label: BECLabel?

    func setupUsing(formulaesCount: Driver<Int>, title: String) {
        _label = nil
        _bag = DisposeBag()

        formulaesCount
            .map({ return "\($0) formulaes" })
            .drive(self.formulaesCountTextField.rx.text)
            .disposed(by: _bag)

        self.titleTextField.stringValue = title
    }

    func setup(using label: BECLabel) {
        self.setupUsing(formulaesCount: label.formulaesCount.asDriver(), title: label.name!)
        _label = label
    }
}
