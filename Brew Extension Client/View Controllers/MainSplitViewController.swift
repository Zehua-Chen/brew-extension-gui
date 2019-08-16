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

class MainSplitViewController: NSSplitViewController {

    var manager = CoreDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    lazy var addLabelViewController: AddLabelViewController = {
        let controller = self.storyboard?.instantiateController(withIdentifier: "addLabelViewController") as! AddLabelViewController
        controller.hostViewController = self

        return controller
    }()

    lazy var syncViewController: SyncViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "syncViewController") as! SyncViewController
    }()

    lazy var removeFormulaeViewController: RemoveFormulaeViewController = {
        let controller = self.storyboard?.instantiateController(withIdentifier: "removeFormulaeViewController") as! RemoveFormulaeViewController
        controller.hostViewController = self

        return controller
    }()

    @IBAction func syncBrewExtension(_ sender: Any) {
        self.presentAsSheet(self.syncViewController)
        // TODO Sync
    }

    @IBAction func addLabel(_ sender: Any) {
        self.presentAsSheet(self.addLabelViewController)
    }

    func removeFormulae(_ notification: Notification) {
        // TODO Remove
        self.presentAsSheet(self.removeFormulaeViewController)
    }
}
