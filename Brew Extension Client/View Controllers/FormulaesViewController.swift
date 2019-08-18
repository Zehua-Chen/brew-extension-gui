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

    fileprivate var _cache = AppDelegate.sharedCache
    fileprivate var _disposeBag = DisposeBag()
    fileprivate var _formulaes = [Formulae]()

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

        _cache.currentFormulaes
            .bind(onNext: { [unowned self] formulaes in
                self._formulaes = formulaes
                self.tableView.reloadData()
            })
            .disposed(by: _disposeBag)
    }

    // MARK: Event handlers

    func onRemoveFormulae(_ action: NSTableViewRowAction, _ row: Int) {
        // TODO: Remove formulae
        _cache.onRemoveFormulae.onNext(_formulaes[row])
    }

    func onProtectFormulae(_ action: NSTableViewRowAction, _ row: Int) {
        self.tableView.rowActionsVisible = false
        _cache.protectFormulae(&_formulaes[row])
        self.tableView.reloadData(forRowIndexes: .init(integer: row), columnIndexes: .init(integer: 0))
    }

    func onUnprotectFormulae(_ action: NSTableViewRowAction, _ row: Int) {
        self.tableView.rowActionsVisible = false
        _cache.unprotectFormulae(&_formulaes[row])
        self.tableView.reloadData(forRowIndexes: .init(integer: row), columnIndexes: .init(integer: 0))
    }

    // MAKR: NSTableView protocols conformance

    func numberOfRows(in tableView: NSTableView) -> Int {
        return _formulaes.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard row < _formulaes.count else { return nil }

        let view = tableView.makeView(withIdentifier: .init("formulaeCellView"), owner: nil) as! FormulaeCellView

        view.titleTextField.stringValue = _formulaes[row].name
        view.labelsTextField.stringValue = "Label: "

        if _formulaes[row].isProtected {
            view.protectionIcon.image = NSImage(named: NSImage.lockLockedTemplateName)
        } else {
            view.protectionIcon.image = NSImage(named: NSImage.lockUnlockedTemplateName)
        }

        return view
    }

    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        switch edge {
        case .leading:
            return [_protectRowAction, _unprotectRowAction]
        case .trailing:
            return [
                .init(style: .destructive, title: "Remove", handler: self.onRemoveFormulae),
            ]
        @unknown default:
            return []
        }
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard self.tableView.selectedRow < _formulaes.count else { return }
        guard self.tableView.selectedRow > 0 else { return }
        
        _cache.currentFormulae.onNext(_formulaes[self.tableView.selectedRow])
    }
    
}
