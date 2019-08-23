//
//  TextCellView.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class CheckboxCellView: NSTableCellView {

    @IBOutlet weak var checkboxButton: NSButton!

    fileprivate var _formulae: BECFormulae!
    fileprivate var _label: BECLabel!
    fileprivate var _bag: DisposeBag!

    func setupUsing(formulae: BECFormulae, label: BECLabel) {
        _formulae = formulae
        _label = label
        _bag = .init()

        _formulae.observalbleLabels.asDriver()
            .map({ [unowned self] labels -> NSControl.StateValue in
                if labels.contains(self._label) {
                    return .on
                }

                return .off
            })
            .drive(self.checkboxButton.rx.state)
            .disposed(by: _bag)

        if formulae.labels!.contains(label) {
            self.checkboxButton.state = .on
        } else {
            self.checkboxButton.state = .off
        }

        self.checkboxButton.title = label.name!
    }
    
    @IBAction func onCheckBoxClicked(_ sender: Any) {
        switch self.checkboxButton.state {
        case .on:
            _formulae.addToLabels(_label)
        case .off:
            _formulae.removeFromLabels(_label)
        default:
            break
        }
    }
}
