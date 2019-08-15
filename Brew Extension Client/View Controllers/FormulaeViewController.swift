//
//  FormulaeViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa

class FormulaeViewController: NSViewController {

    class DependencyDelegateAndDataSource: NSObject, NSTableViewDelegate, NSTableViewDataSource {
        var brewExt = AppDelegate.shared.brewExtension
        var outcomings = [String]()
        var incomings = [String]()

        var formulae = "" {
            didSet {
                self.outcomings = [String](self.brewExt.dataBase!.outcomingDependencies(for: self.formulae))
                self.incomings = [String](self.brewExt.dataBase!.incomingDependencies(for: self.formulae))
            }
        }

        func tableView(
            _ tableView: NSTableView,
            viewFor tableColumn: NSTableColumn?,
            row: Int
        ) -> NSView? {
            switch tableColumn!.title {
            case "Depending on":
                guard row < self.outcomings.count else { return nil }

                let view = tableView.makeView(withIdentifier: .init("dependencyCellView"), owner: nil) as! NSTableCellView
                view.textField?.stringValue = outcomings[row]

                return view
            case "Depended by":
                guard row < self.incomings.count else { return nil }

                let view = tableView.makeView(withIdentifier: .init("dependencyCellView"), owner: nil) as! NSTableCellView
                view.textField?.stringValue = incomings[row]

                return view
            default:
                return nil
            }
        }

        func numberOfRows(in tableView: NSTableView) -> Int {
            if self.outcomings.count > self.incomings.count {
                return self.outcomings.count
            }

            return self.incomings.count
        }
    }

    class LabelDelegateAndDataSource: NSObject, NSTableViewDelegate, NSTableViewDataSource {
        var brewExt = AppDelegate.shared.brewExtension
        var labels = [String]()
        var labelsOfThisFormulae = Set<String>()

        var formulae = "" {
            didSet {
                self.labels = self.brewExt.labels()
                self.labelsOfThisFormulae = self.brewExt.dataBase!.labels(of: self.formulae)
            }
        }

        func numberOfRows(in tableView: NSTableView) -> Int {
            return self.labels.count
        }

        func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            let view = tableView.makeView(withIdentifier: .init("labelCheckboxCellView"), owner: nil) as! LabelCheckboxCellView
            view.checkboxButton.title = self.labels[row]
            view.formulae = self.formulae

            if self.labelsOfThisFormulae.contains(self.labels[row]) {
                view.checkboxButton.state = .on
            } else {
                view.checkboxButton.state = .off
            }

            return view
        }
    }

    @IBOutlet weak var isProtectedCheckBox: NSButton!
    @IBOutlet weak var formulaeTitleLabel: NSTextField!
    @IBOutlet weak var dependencyTableView: NSTableView!
    @IBOutlet weak var labelTableView: NSTableView!
    
    var notificationCenter = NotificationCenter.default
    var formulae: String?
    var brewExt = AppDelegate.shared.brewExtension

    var dependencyDelegateAndDataSource = DependencyDelegateAndDataSource()
    var labelDelegateAndDataSource = LabelDelegateAndDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        self.notificationCenter.addObserver(
            forName: .formulaeSelected,
            object: nil,
            queue: nil,
            using: self.formulaeSelected)

        self.notificationCenter.addObserver(
            forName: .formulaeProtectionChanged,
            object: nil,
            queue: nil,
            using: self.formulaeProtectionChanged)

        self.notificationCenter.addObserver(
            forName: .labelsAdded,
            object: nil,
            queue: nil,
            using: self.labelsChanged)

        self.notificationCenter.addObserver(
            forName: .labelsRemoved,
            object: nil,
            queue: nil,
            using: self.labelsChanged)

        self.dependencyTableView.delegate = self.dependencyDelegateAndDataSource
        self.dependencyTableView.dataSource = self.dependencyDelegateAndDataSource

        self.labelTableView.delegate = self.labelDelegateAndDataSource
        self.labelTableView.dataSource = self.labelDelegateAndDataSource
    }

    func formulaeSelected(_ notification: Notification) {
        self.formulae = notification.userInfo?["formulae"] as? String

        if self.formulae != nil {
            self.formulaeTitleLabel.stringValue = self.formulae!

            self.dependencyDelegateAndDataSource.formulae = formulae!
            self.labelDelegateAndDataSource.formulae = formulae!

            self.dependencyTableView.reloadData()
            self.labelTableView.reloadData()

            self.isProtectedCheckBox.state = _isCurrentFormulaeProtected() ? .on : .off
        }
    }

    func formulaeProtectionChanged(_ notification: Notification) {
        guard let changedFormulae = notification.userInfo?["formulae"] as? String else { return }
        guard let currentFormulae = self.formulae else { return }

        if currentFormulae == changedFormulae {
            self.isProtectedCheckBox.state = _isCurrentFormulaeProtected() ? .on : .off
        }
    }

    func labelsChanged(_ notification: Notification) {
        self.labelDelegateAndDataSource.formulae = self.formulae!
        self.labelTableView.reloadData()
    }

    @IBAction func onIsProtectedClicked(_ sender: Any) {
        guard let formulae = self.formulae else { return }

        if _isCurrentFormulaeProtected() {
            self.brewExt.unprotectFormulae(formulae)
        } else {
            self.brewExt.protectFormulae(formulae)
        }
    }

    fileprivate func _isCurrentFormulaeProtected() -> Bool {
        return self.brewExt.dataBase?.protectsFormulae(self.formulae!) ?? false
    }
}
