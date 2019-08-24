//
//  NSTableView+Rx.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/19/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import RxSwift
import RxCocoa
import Cocoa

extension NSTableView: HasDelegate {

}

fileprivate class _NSTableViewDelegateProxy:
    DelegateProxy<NSTableView, NSTableViewDelegate>,
    DelegateProxyType,
    NSTableViewDelegate {

    weak var _tableView: NSTableView?
    var _selectedRow = BehaviorRelay<Int>(value: 0)

    init(tableView: NSTableView) {
        _tableView = tableView
        super.init(parentObject: tableView, delegateProxy: _NSTableViewDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        self.register(make: { _NSTableViewDelegateProxy(tableView: $0) })
    }

    // MARK: NSTableViewDelegate Conformance

    func tableViewSelectionDidChange(_ notification: Notification) {
        _selectedRow.accept(_tableView?.selectedRow ?? 0)
        self.forwardToDelegate()?.tableViewSelectionDidChange?(notification)
    }
}

extension Reactive where Base: NSTableView {
    var selectedRow: Observable<Int> {
        let delegate = _NSTableViewDelegateProxy.proxy(for: self.base)

        return Observable<Int>.deferred({ return delegate._selectedRow.asObservable() })
    }
}
