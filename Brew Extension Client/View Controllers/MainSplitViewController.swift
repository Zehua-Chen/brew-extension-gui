//
//  MainSplitViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import Dispatch
import BrewExtension
import RxSwift

class MainSplitViewController: NSSplitViewController {

    lazy var addLabelViewController: AddLabelViewController = {
        let controller = self.storyboard?.instantiateController(withIdentifier: "addLabelViewController") as! AddLabelViewController

        return controller
    }()

    lazy var syncViewController: SyncViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "syncViewController") as! SyncViewController
    }()

    lazy var removeFormulaeViewController: RemoveFormulaeViewController = {
        let controller = self.storyboard?.instantiateController(withIdentifier: "removeFormulaeViewController") as! RemoveFormulaeViewController

        return controller
    }()

    fileprivate var _cache = AppDelegate.sharedDatabase
    fileprivate var _disposeBag = DisposeBag()

    override func responds(to aSelector: Selector!) -> Bool {
        switch aSelector {
        case #selector(removeSelectedFormulae(_:)):
            return true
        case #selector(addLabel(_:)):
            return true
        case #selector(syncBrewExtension(_:)):
            return true
        default:
            return super.responds(to: aSelector)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func syncBrewExtension(_ sender: Any) {
        self.presentAsSheet(self.syncViewController)
    }

    @IBAction func addLabel(_ sender: Any) {
        self.presentAsSheet(self.addLabelViewController)
    }

    /// Remove a formulae
    ///
    /// - Parameter formulae: the formulae to delete
    @IBAction func removeSelectedFormulae(_ formulae: Any) {
        self.presentAsSheet(self.removeFormulaeViewController)
    }

//    func removeFormulae(_ formulae: Formulae) {
//        // TODO Remove
//        self.removeFormulaeViewController.formulae = formulae
//        self.presentAsSheet(self.removeFormulaeViewController)
//    }
}
