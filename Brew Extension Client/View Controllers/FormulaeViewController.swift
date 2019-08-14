//
//  FormulaeViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa

class FormulaeViewController: NSViewController {

    class DependencyDelegateAndDataSource: NSObject, NSTableViewDelegate, NSTableViewDataSource {
        
    }

    @IBOutlet weak var formulaeTitleLabel: NSTextField!

    var notificationCenter = NotificationCenter.default
    var formulae: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        self.notificationCenter.addObserver(
            forName: .formulaeClicked,
            object: nil,
            queue: nil,
            using: self.formulaeClicked)
    }

    func formulaeClicked(_ notification: Notification) {
        self.formulae = notification.userInfo?["formulae"] as? String

        if self.formulae != nil {
            self.formulaeTitleLabel.stringValue = self.formulae!
        }
    }
}
