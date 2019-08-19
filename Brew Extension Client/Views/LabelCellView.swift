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

    func setupUsing(formulaesCount: Driver<Int>, title: String) {
        _bag = DisposeBag()

        formulaesCount
            .map({ return "\($0) formulaes" })
            .drive(self.formulaesCountTextField.rx.text)
            .disposed(by: _bag)

        self.titleTextField.stringValue = title
    }
}
