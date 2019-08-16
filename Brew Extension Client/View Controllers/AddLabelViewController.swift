//
//  AddLabelViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import RxSwift

class AddLabelViewController: NSViewController {
    
    @IBOutlet weak var labelField: NSTextField!
    var cache = AppDelegate.sharedCache
    
    @IBAction func onAddLabelClick(_ sender: Any) {
        // TODO Add Label
        if !labelField.stringValue.isEmpty {
            cache.addLabel(labelField.stringValue)
        }

        self.presentingViewController?.dismiss(self)
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.presentingViewController?.dismiss(self)
    }
}
