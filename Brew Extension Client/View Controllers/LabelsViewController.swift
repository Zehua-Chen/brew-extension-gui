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
    var brewExt = AppDelegate.shared.brewExtension
    var labels = [String]()
    var removeIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.labels = brewExt.labels()

        self.notificationCenter.addObserver(
            forName: .labelsAdded,
            object: nil,
            queue: nil,
            using: self.labelsAdded)

        self.notificationCenter.addObserver(
            forName: .labelsRemoved,
            object: nil,
            queue: nil,
            using: self.labelsRemoved)
    }

    // MARK: Event handlers

    func onDeleteRowActionFired(_ action: NSTableViewRowAction, _ rowIndex: Int) {
        self.removeIndex = rowIndex
        try! self.brewExt.removeLabel(labels[rowIndex - 1])
    }

    func labelsRemoved(_ notification: Notification) {
        self.tableView.removeRows(at: .init(integer: self.removeIndex), withAnimation: .slideLeft)
        self.labels = self.brewExt.labels()
        self.tableView.reloadData()
    }

    func labelsAdded(_ notification: Notification) {
        self.tableView.insertRows(at: .init(integer: self.labels.count), withAnimation: .slideRight)
        self.labels = self.brewExt.labels()
        self.tableView.reloadData()
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
        let selectedRow = self.tableView.selectedRow

        if selectedRow <= 0 {
            self.notificationCenter.post(
                name: .labelsSelected,
                object: nil,
                userInfo: [:])
            return
        }

        let label = self.labels[selectedRow - 1]
        self.brewExt.selectLabel(label)
    }
}
