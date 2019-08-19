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

    fileprivate var _cache = AppDelegate.sharedCache
    fileprivate var _disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

//        _cache.onRemoveFormulae
//            .bind(onNext: { [unowned self] formulae in
//                self.removeFormulae(formulae)
//            })
//            .disposed(by: _disposeBag)
    }

    @IBAction func syncBrewExtension(_ sender: Any) {
        self.presentAsSheet(self.syncViewController)
        // TODO Sync
    }

    @IBAction func addLabel(_ sender: Any) {
        self.presentAsSheet(self.addLabelViewController)
        
    }

//    func removeFormulae(_ formulae: Formulae) {
//        // TODO Remove
//        self.removeFormulaeViewController.formulae = formulae
//        self.presentAsSheet(self.removeFormulaeViewController)
//    }
}
