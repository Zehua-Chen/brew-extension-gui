//
//  TextCellView.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import RxCocoa

class CheckboxCellView: NSTableCellView {

    @IBOutlet weak var checkboxButton: NSButton!
    var cache = AppDelegate.sharedDatabase
    var formulae = ""
    
    @IBAction func onCheckBoxClicked(_ sender: Any) {
//        guard !formulae.isEmpty else { return }
//
//        switch self.checkboxButton.state {
//        case .on:
//            cache.addLabel(checkboxButton.title, to: formulae)
//        case .off:
//            cache.removeLabel(checkboxButton.title, from: formulae)
//        default:
//            break
//        }
//
//        cache.currentFormulaeLabelUpdated.onNext(())
    }
}
