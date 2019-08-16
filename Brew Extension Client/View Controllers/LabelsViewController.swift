//
//  LabelsViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa
import Differ

class LabelsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView!

    private let _disposeBag = DisposeBag()
    private var _cache = AppDelegate.sharedCache
    private var _labels = [Label]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        _cache.labels.bind(onNext: { [unowned self] updates in
            let old = self._labels
            self._labels = updates

            // Update table view
            self.tableView.animateRowChanges(
                oldData: old,
                newData: updates,
                deletionAnimation: [.effectFade],
                insertionAnimation: [.effectGap],
                indexPathTransform: self._indexPathTransform)
        }).disposed(by: _disposeBag)
    }

    fileprivate func _indexPathTransform(_ index: IndexPath) -> IndexPath {
        // Needs to make sure that either the inserted or removed index never
        // write to index 0, which is "All"
        var i = index
        i[1] = i[1] + 1

        return i
    }

    // MARK: NSTableView Related

    func onDeleteRowActionFired(_ action: NSTableViewRowAction, _ rowIndex: Int) {
        guard rowIndex > 0 else { return }
        _cache.removeLabel(_labels[rowIndex - 1].name)
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return _labels.count + 1
    }

    func tableView(
        _ tableView: NSTableView,
        viewFor tableColumn: NSTableColumn?,
        row: Int
    ) -> NSView? {
        let view = tableView.makeView(withIdentifier: .init("labelCellView"), owner: nil) as! LabelCellView

        if row == 0 {
            view.titleTextField.stringValue = "All"
            view.formulaesCountTextField.stringValue = "\(_cache.numberOfFormulaes()) formulaes"

            return view
        }

        let labelsIndex = row - 1

        guard labelsIndex < _labels.count else { return nil }

        let label = _labels[labelsIndex]

        view.titleTextField.stringValue = label.name
        view.formulaesCountTextField.stringValue = "\(label.numberOfFormulaes) formulaes"

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
        if self.tableView.selectedRow == 0 {
            _cache.currentLabel.accept(nil)
        } else {
            _cache.currentLabel.accept(_labels[self.tableView.selectedRow - 1])
        }
    }
}
