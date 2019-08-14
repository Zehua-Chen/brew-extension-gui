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

    @IBAction func syncBrewExtension(_ sender: Any) {
        let controller = self.storyboard?.instantiateController(withIdentifier: "syncViewController") as! SyncViewController
        self.presentAsSheet(controller)

        let backgroundContext = self.manager.backgroundContext

        backgroundContext.perform {
            let database = DataBase(context: backgroundContext)
            let ext = AppDelegate.shared.brewExtension

            ext.dataBase = database
            try! ext.sync()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(controller)
            }
        }
    }
}
