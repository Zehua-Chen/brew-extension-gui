//
//  FormulaesViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa

class FormulaesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    func removeFormulae(_ action: NSTableViewRowAction, _ row: Int) {

    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return 10
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return tableView.makeView(withIdentifier: .init("formulaeCellView"), owner: nil)
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
