//
//  RemoveFormulaeViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/15/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import BrewExtension

class RemoveFormulaeViewController:
    NSViewController,
    NSTableViewDelegate,
    NSTableViewDataSource,
    FindUninstallablesOperation,
    UninstallOperation {
//    var removes = [Formulae](

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var titleTextField: NSTextField!

    fileprivate var _removes: [String] = []
    fileprivate var _database: ObservableDatabase = AppDelegate.sharedDatabase
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        let wrapper = _database.makeDataSourceWrapper()
        guard let name = _database.currentFormulae.value?.name else { return }

        _removes = self.findUninstallableFormulaes(for: name, using: wrapper)
        self.titleTextField.stringValue = "The following formulaes will be removed"
        self.tableView.reloadData()
    }
    
    @IBAction func onConfirmClicked(_ sender: Any) {
        // TODO Remove formulae
        var wrapper = _database.makeDataSourceWrapper()

        for remove in _removes {
            try! self.uninstallFormulae(remove, with: .init(), using: &wrapper)
        }

        try! _database.context.save()

        self.presentingViewController?.dismiss(self)
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        self.presentingViewController?.dismiss(self)
    }

    // MARK: NSTableView protocol conformance

    func numberOfRows(in tableView: NSTableView) -> Int {
        return _removes.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: .init("removeTableCellView"), owner: nil) as! NSTableCellView
        view.textField?.stringValue = _removes[row]

        return view
    }
}
