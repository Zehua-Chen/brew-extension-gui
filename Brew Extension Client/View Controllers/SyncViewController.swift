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
        context.perform {
            var cache = CoreDataCache(context: context)

            try! self.sync(into: &cache, using: .init())
            cache.write()

            DispatchQueue.main.async {
                AppDelegate.sharedCache.finishSync()
                self.presentingViewController?.dismiss(self)
            }
        }
    }
}
