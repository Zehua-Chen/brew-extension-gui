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
import RxCocoa

class FormulaesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!

    fileprivate var _database = AppDelegate.sharedDatabase
    fileprivate var _bag = DisposeBag()
    fileprivate var _formulaes = [BECFormulae]()

    fileprivate var _protectRowAction: NSTableViewRowAction!
    fileprivate var _unprotectRowAction: NSTableViewRowAction!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        _protectRowAction = NSTableViewRowAction(
            style: .regular,
            title: "Protect",
            handler: self.onProtectFormulae)

        _protectRowAction.image = NSImage(named: NSImage.lockLockedTemplateName)

        _unprotectRowAction = NSTableViewRowAction(
            style: .regular,
            title: "Unprotect",
            handler: self.onUnprotectFormulae)

        _unprotectRowAction.backgroundColor = .systemOrange
        _unprotectRowAction.image = NSImage(named: NSImage.lockUnlockedTemplateName)

        _database.currentFormulaes
            .asDriver()
            .drive(onNext: { [unowned self] formulaes in
                self._formulaes = formulaes
                self.tableView.reloadData()
                self.tableView.selectRowIndexes(.init(integer: 0), byExtendingSelection: false)
            })
            .disposed(by: _bag)

        self.tableView.rx.selectedRow
            .map({ [unowned self] row in
                return self._formulaes[row]
            })
            .subscribe(onNext: { [unowned self] formulae in
                self._database.selectFormulae(formulae)
            })
            .disposed(by: _bag)
    }

    // MARK: Event handlers

    func onRemoveFormulae(_ action: NSTableViewRowAction, _ row: Int) {
        // TODO: Remove formulae
//        _cache.onRemoveFormulae.onNext(_formulaes[row])
    }

    func onProtectFormulae(_ action: NSTableViewRowAction, _ row: Int) {
        self.tableView.rowActionsVisible = false
        _formulaes[row].isProtected = true
    }

    func onUnprotectFormulae(_ action: NSTableViewRowAction, _ row: Int) {
        self.tableView.rowActionsVisible = false
        _formulaes[row].isProtected = false
    }

    // MAKR: NSTableView protocols conformance

    func numberOfRows(in tableView: NSTableView) -> Int {
        return _formulaes.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard row < _formulaes.count else { return nil }

        let view = tableView.makeView(withIdentifier: .formulaeCellView, owner: nil) as! FormulaeCellView
        view.setup(using: _formulaes[row])

        return view
    }

    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        switch edge {
        case .leading:
            if _formulaes[row].isProtected {
                return [_unprotectRowAction]
            }

            return [_protectRowAction]
        case .trailing:
            return [
                .init(style: .destructive, title: "Remove", handler: self.onRemoveFormulae),
            ]
        @unknown default:
            return []
        }
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
//        guard self.tableView.selectedRow < _formulaes.count else { return }
//        guard self.tableView.selectedRow > 0 else { return }
//        
//        _cache.currentFormulae.onNext(_formulaes[self.tableView.selectedRow])
    }
    
}
