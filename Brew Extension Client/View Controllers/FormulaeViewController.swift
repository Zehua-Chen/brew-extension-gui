//
//  FormulaeViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class FormulaeViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var isProtectedCheckBox: NSButton!
    @IBOutlet weak var formulaeTitleLabel: NSTextField!
    @IBOutlet weak var dependencyTableView: NSTableView!
    @IBOutlet weak var labelTableView: NSTableView!

    fileprivate let _cache = AppDelegate.sharedCache
    fileprivate let _disposeBag = DisposeBag()
    fileprivate var _incomings = [Formulae]()
    fileprivate var _outcomings = [Formulae]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        _cache.currentFormulae
            .map({ return $0?.name ?? "?" })
            .bind(to: self.formulaeTitleLabel.rx.text)
            .disposed(by: _disposeBag)

        _cache.currentFormulaeProtected.map { protected -> NSControl.StateValue in
            switch protected {
            case true:
                return .on
            case false:
                return .off
            }
        }.bind(to: self.isProtectedCheckBox.rx.state).disposed(by: _disposeBag)

        _cache.currentFormulaeOutcomingDependencies.bind(onNext: { [unowned self] formulaes in
            self._outcomings = formulaes
            self.dependencyTableView.reloadData()
        }).disposed(by: _disposeBag)

        _cache.currentFormulaeIncomingDependencies.bind(onNext: { [unowned self] formulaes in
            self._incomings = formulaes
            self.dependencyTableView.reloadData()
        }).disposed(by: _disposeBag)

        self.isProtectedCheckBox.rx.state.bind(onNext: { [unowned self] state in
            guard let formulaeName = try! self._cache.currentFormulae.value()?.name else { return }

            switch state {
            case .on:
                self._cache.protectFormulae(formulaeName)
            case .off:
                self._cache.unprotectFormulae(formulaeName)
            default:
                break
            }
        }).disposed(by: _disposeBag)
    }

    func labelsChanged(_ notification: Notification) {
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        switch tableView.tag {
        // MARK: Depdency Table
        case 0:
            if _outcomings.count > _incomings.count {
                return _outcomings.count
            }

            return _incomings.count
        // MARK: Label Table
        case 1:
            return 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        switch tableView.tag {
        // MARK: Depdency Table
        case 0:
            let view = tableView.makeView(withIdentifier: .init("dependencyCellView"), owner: nil) as! NSTableCellView

            switch tableColumn!.title {
            case "Depending on":
                guard row < _outcomings.count else { return nil }
                view.textField?.stringValue = _outcomings[row].name

                return view
            case "Depended by":
                guard row < _incomings.count else { return nil }
                view.textField?.stringValue = _incomings[row].name

                return view
            default:
                return nil
            }
        // MARK: Label Table
        case 1:
            return nil
        default:
            return nil
        }
    }
}
