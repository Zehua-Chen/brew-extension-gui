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

    lazy var addLabelViewController: AddLabelViewController = {
        let controller = self.storyboard?.instantiateController(withIdentifier: "addLabelViewController") as! AddLabelViewController
        controller.hostViewController = self

        return controller
    }()

    lazy var syncViewController: SyncViewController = {
        return self.storyboard?.instantiateController(withIdentifier: "syncViewController") as! SyncViewController
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
}
