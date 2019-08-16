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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        _cache.currentFormulaes.bind(onNext: { [unowned self] formulaesUpdate in

            if !formulaesUpdate.shouldAnimate {
                self._formulaes = formulaesUpdate.formulaes
                self.tableView.reloadData()

                return
            }

            let oldFormulaes = self._formulaes
            self._formulaes = formulaesUpdate.formulaes

            self.tableView.animateRowChanges(
                oldData: oldFormulaes,
                newData: formulaesUpdate.formulaes,
                deletionAnimation: .effectFade,
                insertionAnimation: .slideLeft)
        }).disposed(by: _disposeBag)
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
