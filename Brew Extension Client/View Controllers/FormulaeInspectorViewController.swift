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
    fileprivate let _bag: DisposeBag = .init()
    fileprivate var _incomings: [BECLabel] = []
    fileprivate var _outcomings: [BECLabel] = []
    fileprivate var _labels: [BECLabel] = []
//    fileprivate var _currentFormulae: Formulae?

    override func viewDidLoad() {
        super.viewDidLoad()

        _database.labels.asDriver()
            .drive(onNext: { [unowned self] labels in
                self._labels = labels
                self.labelTableView.reloadData()
            })
            .disposed(by: _bag)

//        _database.currentFormulae.
//
//        _cache.currentFormulae
//            .bind(onNext: { [unowned self] formulae in
//                self._currentFormulae = formulae
//            })
//            .disposed(by: _disposeBag)
//
//        _cache.currentFormulaeProtected
//            .map({ protected -> NSControl.StateValue in
//                switch protected {
//                case true:
//                    return .on
//                case false:
//                    return .off
//                }
//            })
//            .bind(to: self.isProtectedCheckBox.rx.state).disposed(by: _disposeBag)
//
//        _cache.currentFormulaeOutcomingDependencies
//            .bind(onNext: { [unowned self] formulaes in
//                self._outcomings = formulaes
//                self.dependencyTableView.reloadData()
//            })
//            .disposed(by: _disposeBag)
//
//        _cache.currentFormulaeIncomingDependencies
//            .bind(onNext: { [unowned self] formulaes in
//                self._incomings = formulaes
//                self.dependencyTableView.reloadData()
//            })
//            .disposed(by: _disposeBag)
//
//        _cache.labels
//            .bind(onNext: { [unowned self] labels in
//                self._labels = labels
//                self.labelTableView.reloadData()
//            })
//            .disposed(by: _disposeBag)

//        self.isProtectedCheckBox.rx.state
//            .bind(onNext: { [unowned self] state in
//                guard let formulaeName = try! self._cache.currentFormulae.value()?.name else { return }
//
//                switch state {
//                case .on:
//                    self._cache.protectFormulae(formulaeName)
//                case .off:
//                    self._cache.unprotectFormulae(formulaeName)
//                default:
//                    break
//                }
//            })
//            .disposed(by: _disposeBag)
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

            guard let current = _database.currentFormulae.value else { return nil }
            view.setupUsing(formulae: current, label: _labels[row])

            return view
        default:
            return nil
        }
    }
}
