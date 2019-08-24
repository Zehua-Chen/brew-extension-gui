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

        self.tableView.rx.selectedRow
            .bind(onNext: { [unowned self] row in
                if row == 0 {
                    self._database.selectLabel(nil)
                    return
                }

                let actualRow = row - 1

                if actualRow < self._labels.count && actualRow > -1 {
                    self._database.selectLabel(self._labels[actualRow])
                    return
                }

                self._database.selectLabel(nil)
            })
            .disposed(by: _bag)
    }

    fileprivate func _indexPathTransform(_ index: IndexPath) -> IndexPath {
        // Needs to make sure that either the inserted or removed index never
        // write to index 0, which is "All"
        var i = index
        i[1] = i[1] + 1

        return i
    }

    @IBAction func removeSelectedLabel(_ sender: Any) {
        let index = self.tableView.selectedRow - 1
        guard index >= 0 && index < _labels.count else { return }

        _database.deleteLabel(_labels[index])
    }

    // MARK: NSTableView Related

    func onDeleteRowActionFired(_ action: NSTableViewRowAction, _ rowIndex: Int) {
        let index = rowIndex - 1
        guard index >= 0 else { return }

        _database.deleteLabel(_labels[index])
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

        view.setup(using: _labels[labelsIndex])

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
}
