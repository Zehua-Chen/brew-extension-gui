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

    @IBAction func onCheckboxButtonClicked(_ sender: Any) {
    }
}

class LabelCheckboxCellView: CheckboxCellView {
}
