//
//  FormulaesViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa

class FormulaesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    var notificationCenter = NotificationCenter.default
    var labelFilter: String?
    var brewExt = AppDelegate.shared.brewExtension

    var formulaes = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        self.notificationCenter.addObserver(
            forName: .init("labelChanged"),
            object: nil,
            queue: nil,
            using: self.labelChanged)

        self.formulaes = self.brewExt.formulaes()
    }

    func labelChanged(_ notification: Notification) {
        guard let newLabel = notification.userInfo?["label"] as? String else {
            self.formulaes = self.brewExt.formulaes()
            self.tableView.reloadData()
            return
        }

        self.formulaes = []

        for formulae in self.brewExt.formulaes(under: newLabel) {
            self.formulaes.append(formulae)
        }

        self.tableView.reloadData()
    }

    func removeFormulae(_ action: NSTableViewRowAction, _ row: Int) {

    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return formulaes.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: .init("formulaeCellView"), owner: nil) as! FormulaeCellView
        view.titleTextField.stringValue = self.formulaes[row]
        view.labelsTextField.stringValue = "Label: \(self.labelFilter ?? "")"
        view.protectionIcon.image = NSImage(named: NSImage.lockLockedTemplateName)

        return view
    }

    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        switch edge {
        case .leading:
            return []
        case .trailing:
            return [.init(style: .destructive, title: "Remove", handler: self.removeFormulae)]
        @unknown default:
            return []
        }
    }
    
}
