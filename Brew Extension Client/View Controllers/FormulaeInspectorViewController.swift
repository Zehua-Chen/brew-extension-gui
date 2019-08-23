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

class FormulaeInspectorViewController:
    NSViewController,
    NSTableViewDelegate,
    NSTableViewDataSource {

    @IBOutlet weak var isProtectedCheckBox: NSButton!
    @IBOutlet weak var formulaeTitleLabel: NSTextField!
    @IBOutlet weak var dependencyTableView: NSTableView!
    @IBOutlet weak var labelTableView: NSTableView!

    fileprivate let _database: ObservableDatabase = AppDelegate.sharedDatabase

    fileprivate let _persistantBag: DisposeBag = .init()
    fileprivate var _selectionBag: DisposeBag = .init()

    fileprivate var _incomings: [BECLabel] = []
    fileprivate var _outcomings: [BECLabel] = []
    fileprivate var _labels: [BECLabel] = []

    fileprivate var _formulae: BECFormulae?

    override func viewDidLoad() {
        super.viewDidLoad()

        _database.labels.asDriver()
            .drive(onNext: { [unowned self] labels in
                self._labels = labels
                self.labelTableView.reloadData()
            })
            .disposed(by: _persistantBag)

        let currentFormulaeDriver = _database.currentFormulae.asDriver()

        currentFormulaeDriver
            .map({ formulae -> String in
                return formulae?.name ?? "?"
            })
            .drive(self.formulaeTitleLabel.rx.text)
            .disposed(by: _persistantBag)

        currentFormulaeDriver
            .drive(onNext: { [unowned self] formulae in
                // MARK: Bind selected formulae
                self._selectionBag = .init()
                self._formulae = formulae
                self.labelTableView.reloadData()

                // Reobserve current formulae
                self._formulae?.obserableIsProtected.asDriver()
                    .map({ protected -> NSControl.StateValue in
                        switch protected {
                        case true:
                            return .on
                        case false:
                            return .off
                        }
                    })
                    .drive(self.isProtectedCheckBox.rx.state)
                    .disposed(by: self._selectionBag)
            })
            .disposed(by: _persistantBag)
    }

    @IBAction func onIsProtectedClick(_ sender: Any) {
        switch self.isProtectedCheckBox.state {
        case .on:
            _formulae?.isProtected = true
        case .off:
            _formulae?.isProtected = false
        default:
            break
        }
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
            return _labels.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        switch tableView.tag {
        // MARK: Depdency Table
        case 0:
            let view = tableView.makeView(
                withIdentifier: .dependencyCellView,
                owner: nil) as! NSTableCellView

            switch tableColumn!.title {
            case "Depending on":
                guard row < _outcomings.count else { return nil }
                return view
            case "Depended by":
                guard row < _incomings.count else { return nil }
                return view
            default:
                return nil
            }
        // MARK: Label Table
        case 1:
            let view = tableView.makeView(
                withIdentifier: .labelCellView,
                owner: nil) as! CheckboxCellView

            guard let formulae = _formulae else { return nil }
            view.setupUsing(formulae: formulae, label: _labels[row])

            return view
        default:
            return nil
        }
    }
}
