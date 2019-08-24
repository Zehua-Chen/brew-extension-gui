//
//  AddLabelViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa

class AddLabelViewController: NSViewController {
    
    @IBOutlet weak var labelField: NSTextField!
    @IBOutlet weak var errorMessageField: NSTextField!
    @IBOutlet weak var addButton: NSButton!
    
    fileprivate var _database = AppDelegate.sharedDatabase

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onAddLabelClick(_ sender: Any) {
        _database.addLabel(labelField.stringValue)
        self.presentingViewController?.dismiss(self)
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.presentingViewController?.dismiss(self)
    }
}
