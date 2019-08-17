//
//  RemoveFormulaeViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/15/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import BrewExtension

class RemoveFormulaeViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, FindUninstallablesOperation {

    var target = ""
    var removes = [Formulae]()
    var formulae: Formulae!

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var titleTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        removes = self.findUninstallableFormulaes(for: formulae.name, cache: AppDelegate.sharedCache)
        self.titleTextField.stringValue = "The following formulaes will be removed"
        self.tableView.reloadData()
    }
    
    @IBAction func onConfirmClicked(_ sender: Any) {
        self.titleTextField.stringValue = "Working"
        // TODO Remove formulae
        self.presentingViewController?.dismiss(self)
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        self.presentingViewController?.dismiss(self)
    }

    // MARK: NSTableView protocol conformance

    func numberOfRows(in tableView: NSTableView) -> Int {
        return removes.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: .init("removeTableCellView"), owner: nil) as! NSTableCellView
        view.textField?.stringValue = removes[row].name
        
        return view
    }
}
