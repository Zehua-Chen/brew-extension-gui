//
//  FormulaesViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import Dispatch
import RxSwift

class FormulaesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!

    fileprivate var _cache = AppDelegate.sharedCache
    fileprivate var _disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        _cache.selectedLabel.subscribe { e in
            if case .next(let selection) = e {
                print("selection = \(selection?.name ?? "default")")
            }
        }.disposed(by: _disposeBag)
    }

    // MARK: Event handlers

    func onRemoveFormulae(_ action: NSTableViewRowAction, _ row: Int) {
        // TODO: Remove formulae
    }

    func onProtectFormulae(_ action: NSTableViewRowAction, _ row: Int) {
        self.tableView.rowActionsVisible = false
        // TODO: Protect formulae
    }

    func onUnprotectFormulae(_ action: NSTableViewRowAction, _ row: Int) {
        self.tableView.rowActionsVisible = false
        // TODO: Protect formulae
    }

    // MAKR: NSTableView protocols conformance

    func numberOfRows(in tableView: NSTableView) -> Int {
        return 0
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: .init("formulaeCellView"), owner: nil) as! FormulaeCellView

//        view.titleTextField.stringValue = formulae
//        view.labelsTextField.stringValue = "Label: \(self.labelFilter ?? "")"
//
//        if self.brewExt.dataBase?.protectsFormulae(formulae) ?? false {
//            view.protectionIcon.image = NSImage(named: NSImage.lockLockedTemplateName)
//        } else {
//            view.protectionIcon.image = NSImage(named: NSImage.lockUnlockedTemplateName)
//        }

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
        // TODO Select row
    }
    
}
