//
//  FormulaesViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import Dispatch

class FormulaesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    var notificationCenter = NotificationCenter.default

    var brewExt = AppDelegate.shared.brewExtension
    var formulaes = [String]()
    var labelFilter: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        self.notificationCenter.addObserver(
            forName: .labelsSelected,
            object: nil,
            queue: nil,
            using: self.onLabelClicked)

        self.notificationCenter.addObserver(
            forName: .formulaeProtectionChanged,
            object: nil,
            queue: nil,
            using: self.onFormulaeProtectionChanged)

        self.notificationCenter.addObserver(
            forName: .formulaeLabelChanged,
            object: nil,
            queue: nil,
            using: self.onFormulaeLabelChanged)

        self.formulaes = self.brewExt.formulaes()
    }

    override func viewDidAppear() {
        if !formulaes.isEmpty {
            self.brewExt.selectFormulae(self.formulaes[0])
        }
    }

    // MARK: Event handlers

    func onLabelClicked(_ notification: Notification) {
        guard let newLabel = notification.userInfo?["label"] as? String else {
            self.formulaes = self.brewExt.formulaes()
            self.tableView.reloadData()
            self.labelFilter = nil
            return
        }

        self.formulaes = []
        self.labelFilter = newLabel

        for formulae in self.brewExt.formulaes(under: newLabel) {
            self.formulaes.append(formulae)
        }

        self.tableView.reloadData()

        if !formulaes.isEmpty {
            self.brewExt.selectFormulae(self.formulaes[0])
        }
    }

    func onFormulaeLabelChanged(_ notification: Notification) {
        guard let filter = self.labelFilter else { return }

        self.formulaes = []

        for formulae in self.brewExt.formulaes(under: filter) {
            self.formulaes.append(formulae)
        }

        self.tableView.reloadData()

        if !formulaes.isEmpty {
            self.brewExt.selectFormulae(self.formulaes[0])
        }
    }

    func onFormulaeProtectionChanged(_ notification: Notification) {
        // Otherwise the slide back animation does not play
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.reloadData()
        }
    }

    func onRemoveFormulae(_ action: NSTableViewRowAction, _ row: Int) {
        // TODO: Remove formulae
    }

    func onProtectFormulae(_ action: NSTableViewRowAction, _ row: Int) {
        self.tableView.rowActionsVisible = false
        self.brewExt.protectFormulae(self.formulaes[row])
    }

    func onUnprotectFormulae(_ action: NSTableViewRowAction, _ row: Int) {
        self.tableView.rowActionsVisible = false
        self.brewExt.unprotectFormulae(self.formulaes[row])
    }

    // MAKR: NSTableView protocols conformance

    func numberOfRows(in tableView: NSTableView) -> Int {
        return formulaes.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let formulae = self.formulaes[row]
        let view = tableView.makeView(withIdentifier: .init("formulaeCellView"), owner: nil) as! FormulaeCellView

        view.titleTextField.stringValue = formulae
        view.labelsTextField.stringValue = "Label: \(self.labelFilter ?? "")"

        if self.brewExt.dataBase?.protectsFormulae(formulae) ?? false {
            view.protectionIcon.image = NSImage(named: NSImage.lockLockedTemplateName)
        } else {
            view.protectionIcon.image = NSImage(named: NSImage.lockUnlockedTemplateName)
        }

        return view
    }

    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        switch edge {
        case .leading:
            return [
                .init(style: .regular, title: "Protect", handler: self.onProtectFormulae),
                .init(style: .destructive, title: "Unprotect", handler: self.onUnprotectFormulae),
            ]
        case .trailing:
            return [
                .init(style: .destructive, title: "Remove", handler: self.onRemoveFormulae),
            ]
        @unknown default:
            return []
        }
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = self.tableView.selectedRow
        let formulae = self.formulaes[selectedRow]

        self.brewExt.selectFormulae(formulae)
    }
    
}
