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
    var notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()

        self.notificationCenter.addObserver(
            forName: .findFormulaeToBeRemovedFor,
            object: nil,
            queue: nil,
            using: self.removeFormulae)
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

        let backgroundContext = self.manager.backgroundContext

        backgroundContext.perform {
            let database = DataBase(context: backgroundContext)
            let ext = BrewExtension()

            ext.dataBase = database
            try! ext.sync()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(self.syncViewController)
            }
        }
    }

    @IBAction func addLabel(_ sender: Any) {
        self.presentAsSheet(self.addLabelViewController)
    }

    func removeFormulae(_ notification: Notification) {
        self.removeFormulaeViewController.target = notification.userInfo!["formulae"] as! String
        self.removeFormulaeViewController.removes = notification.userInfo!["removes"] as! [String]
        self.presentAsSheet(self.removeFormulaeViewController)
    }

}
