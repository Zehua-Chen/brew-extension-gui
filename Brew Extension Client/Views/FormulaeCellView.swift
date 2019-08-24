//
//  FormulaeCellView.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class FormulaeCellView: NSTableCellView {
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var labelsTextField: NSTextField!
    @IBOutlet weak var protectionIcon: NSImageView!

    fileprivate var _bag: DisposeBag!
    fileprivate var _formulae: BECFormulae!

    func setup(using formulae: BECFormulae) {
        _formulae = nil
        _bag = DisposeBag()
        
        titleTextField.stringValue = formulae.name ?? "Error"
        
        formulae.observalbleLabels
            .asDriver()
            .map({ labels -> String in
                let labelsText = labels
                    .map({ return $0.name! })
                    .joined(separator: ",")

                guard labelsText.isEmpty else { return "Labels" }
                return labelsText
            })
            .drive(self.labelsTextField.rx.text)
            .disposed(by: _bag)

        formulae.obserableIsProtected
            .asDriver()
            .map({ isProtected -> NSImage in
                if isProtected {
                    return NSImage(named: NSImage.lockLockedTemplateName)!
                }

                return NSImage(named: NSImage.lockUnlockedTemplateName)!
            })
            .drive(protectionIcon.rx.image)
            .disposed(by: _bag)
    }
}
