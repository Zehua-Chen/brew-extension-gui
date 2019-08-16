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
        _cache.labels
            .subscribe { [weak self] e in
            guard let controller = self else { return }

            switch e {
            case .next(let updates):
                let old = controller._labels
                controller._labels = updates
                controller.tableView.animateRowChanges(
                    oldData: old,
                    newData: updates,
                    deletionAnimation: [.effectFade],
                    insertionAnimation: [.effectGap],
                    indexPathTransform: controller._indexPathTransform)
            default:
                break
            }
        }.disposed(by: _disposeBag)
    }

    fileprivate func _indexPathTransform(_ index: IndexPath) -> IndexPath {
        print("index = \(index)")
//        index.ind
        return index
    }

    // MARK: Event handlers

    func onDeleteRowActionFired(_ action: NSTableViewRowAction, _ rowIndex: Int) {
        _cache.removeLabel(_labels[rowIndex].name)
    }

    // MARK: NSTableViewDataSource Conformance

    func numberOfRows(in tableView: NSTableView) -> Int {
        return _labels.count
    }

    // MARK: NSTableViewDelegate Conformance

    func tableView(
        _ tableView: NSTableView,
        viewFor tableColumn: NSTableColumn?,
        row: Int
    ) -> NSView? {
        let view = tableView.makeView(withIdentifier: .init("labelCellView"), owner: nil) as! LabelCellView

//        if row == 0 {
//            view.titleTextField.stringValue = "All"
//            view.formulaesCountTextField.stringValue = "x formulaes"
//
//            return view
//        }

//        let labelsIndex = row - 1

        guard row < _labels.count else { return nil }

        view.titleTextField.stringValue = _labels[row].name
        view.formulaesCountTextField.stringValue = "x formulaes"

        return view
    }

    func tableView(
        _ tableView: NSTableView,
        rowActionsForRow row: Int,
        edge: NSTableView.RowActionEdge
    ) -> [NSTableViewRowAction] {
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
//        let index = self.tableView.selectedRow - 1
//
//        if index > -1 {
//            _cache.selectLabel(_labels[index])
//        } else {
//            _cache.selectLabel(nil)
//        }
    }
}
