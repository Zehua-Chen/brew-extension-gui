//
//  TextCellView.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa

class CheckboxCellView: NSTableCellView {

    @IBOutlet weak var checkboxButton: NSButton!

    @IBAction func onCheckboxButtonClicked(_ sender: Any) {
        let b = sender as! NSButton
        switch b.state {
        case .on:
            self.onChecked()
        case .off:
            self.onUnChecked()
        default:
            break
        }
    }

    // Overridable Messages

    func onChecked() {}
    func onUnChecked() {}
}

class LabelCheckboxCellView: CheckboxCellView {
    var formulae = ""
    var brewExt = AppDelegate.shared.brewExtension

    override func onChecked() {
        try! self.brewExt.labelFormulae(self.formulae, as: self.checkboxButton.title)
    }

    override func onUnChecked() {
        try! self.brewExt.removeLabel(self.checkboxButton.title, from: self.formulae)
    }
}
