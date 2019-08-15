//
//  AddLabelViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa

class AddLabelViewController: NSViewController {

    weak var hostViewController: NSViewController?
    var brewExt = AppDelegate.shared.brewExtension
    
    @IBOutlet weak var labelField: NSTextField!
    
    @IBAction func onAddLabelClick(_ sender: Any) {
        brewExt.addLabel(self.labelField.stringValue)
        self.hostViewController?.dismiss(self)
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.hostViewController?.dismiss(self)
    }
}
