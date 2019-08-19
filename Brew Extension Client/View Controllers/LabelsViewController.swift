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

    fileprivate let _bag = DisposeBag()
    fileprivate var _database = AppDelegate.sharedDatabase
    fileprivate var _labels = [BECLabel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        _database.labels
            .bind(onNext: { [unowned self] labels in
                if self._labels.isEmpty {
                    self._labels = labels
                    self.tableView.reloadData()
                    
                    return
                }

                let old = self._labels
                self._labels = labels

                // Update table view
                self.tableView.animateRowChanges(
                    oldData: old,
                    newData: labels,
                    deletionAnimation: [.effectFade],
                    insertionAnimation: [.effectGap],
                    indexPathTransform: self._indexPathTransform)
            })
            .disposed(by: _bag)
//
//        _cache.currentFormulaeLabelUpdated
//            .subscribe { e in
//                self.tableView.reloadData()
//            }
//            .disposed(by: _disposeBag)
//
//        self.tableView.rx.selectedRow
//            .bind(onNext: { row in
//                print("selected row = \(row)")
//            })
//            .disposed(by: _disposeBag)
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
        guard rowIndex - 1 > 0 else { return }
        _database.deleteLabel(_labels[rowIndex - 1])
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
            view.setupUsing(
                formulaesCount: _database.formulaesCount.asDriver(),
                title: "All")

            return view
        }

        let labelsIndex = row - 1

        guard labelsIndex < _labels.count else { return nil }

        let label = _labels[labelsIndex]
        view.setupUsing(
            formulaesCount: label.formulaesCount.asDriver(),
            title: label.name!)

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
//        let actualRow = self.tableView.selectedRow - 1
//
//        if actualRow < 0 || actualRow >= _labels.count {
//            _cache.currentLabel.onNext(nil)
//        } else {
//            _cache.currentLabel.onNext(_labels[self.tableView.selectedRow - 1])
//        }
    }
}
