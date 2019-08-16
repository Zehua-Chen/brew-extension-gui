//
//  LabelsViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa

class LabelsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView!
    var notificationCenter = NotificationCenter.default
    var labels = [String]()
    var removeIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    // MARK: Event handlers

    func onDeleteRowActionFired(_ action: NSTableViewRowAction, _ rowIndex: Int) {
        self.removeIndex = rowIndex
    }

    // MARK: NSTableViewDataSource Conformance

    func numberOfRows(in tableView: NSTableView) -> Int {
        return labels.count + 1
    }

    // MARK: NSTableViewDelegate Conformance

    func tableView(
        _ tableView: NSTableView,
        viewFor tableColumn: NSTableColumn?,
        row: Int
    ) -> NSView? {
        let view = tableView.makeView(withIdentifier: .init("labelCellView"), owner: nil) as! LabelCellView

        if row == 0 {
            view.titleTextField.stringValue = "All"
            view.formulaesCountTextField.stringValue = "x formulaes"

            return view
        }

        let labelsIndex = row - 1

        view.titleTextField.stringValue = labels[labelsIndex]
        view.formulaesCountTextField.stringValue = "x formulaes"

        return view
    }

    func tableView(
        _ tableView: NSTableView,
        rowActionsForRow row: Int,
        edge: NSTableView.RowActionEdge
    ) -> [NSTableViewRowAction] {

        if row == 0 {
            return []
        }

        switch edge {
        case .leading:
            return []
        case .trailing:
            return [.init(style: .destructive, title: "Delete", handler: self.onDeleteRowActionFired)]
        @unknown default:
            return []
        }
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
//        let selectedRow = self.tableView.selectedRow
//
//        if selectedRow <= 0 {
//            self.notificationCenter.post(
//                name: .labelsSelected,
//                object: nil,
//                userInfo: [:])
//            return
//        }
//
//        let label = self.labels[selectedRow - 1]
//        self.brewExt.selectLabel(label)
    }
}
