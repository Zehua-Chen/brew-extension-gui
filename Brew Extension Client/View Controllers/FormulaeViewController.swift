//
//  FormulaeViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import RxCocoa

class FormulaeViewController: NSViewController {

    class DependencyDelegateAndDataSource: NSObject, NSTableViewDelegate, NSTableViewDataSource {

        func tableView(
            _ tableView: NSTableView,
            viewFor tableColumn: NSTableColumn?,
            row: Int
        ) -> NSView? {
            return nil
        }

        func numberOfRows(in tableView: NSTableView) -> Int {
            return 0
        }
    }

    class LabelDelegateAndDataSource: NSObject, NSTableViewDelegate, NSTableViewDataSource {

        func numberOfRows(in tableView: NSTableView) -> Int {
            return 0
        }

        func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            let view = tableView.makeView(withIdentifier: .init("labelCheckboxCellView"), owner: nil) as! LabelCheckboxCellView

            return view
        }
    }

    @IBOutlet weak var isProtectedCheckBox: NSButton!
    @IBOutlet weak var formulaeTitleLabel: NSTextField!
    @IBOutlet weak var dependencyTableView: NSTableView!
    @IBOutlet weak var labelTableView: NSTableView!

    var formulae: String?

    var dependencyDelegateAndDataSource = DependencyDelegateAndDataSource()
    var labelDelegateAndDataSource = LabelDelegateAndDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        self.dependencyTableView.delegate = self.dependencyDelegateAndDataSource
        self.dependencyTableView.dataSource = self.dependencyDelegateAndDataSource

        self.labelTableView.delegate = self.labelDelegateAndDataSource
//        self.labelTableView.dataSource = self.labelDelegateAndDataSources
    }

    func labelsChanged(_ notification: Notification) {
    }

    @IBAction func onIsProtectedClicked(_ sender: Any) {
        guard let formulae = self.formulae else { return }
        // TODO Handle protection click
    }
}
