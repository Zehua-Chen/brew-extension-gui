//
//  SyncViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import Dispatch
import BrewExtension

class SyncViewController: NSViewController, SyncOperation {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        let context = CoreDataManager.shared.backgroundContext
        context.perform { [unowned self] in
            let database = Database(context: context)
            var container = database.makeDataSourceWrapper()

            try! self.sync(into: &container, brew: .init())
            try! database.context.save()

            DispatchQueue.main.async { [unowned self] in
                self.presentingViewController?.dismiss(self)
                AppDelegate.sharedDatabase.sync.accept(())
            }
        }
    }
}
