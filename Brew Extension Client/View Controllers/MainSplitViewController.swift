//
//  MainSplitViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import Dispatch

class MainSplitViewController: NSSplitViewController {
    @IBAction func syncBrewExtension(_ sender: Any) {
        let controller = self.storyboard?.instantiateController(withIdentifier: "syncViewController") as! SyncViewController
        self.presentAsSheet(controller)

        DispatchQueue(label: "Homebrew Sync").async {
            // TODO: Sync with homebrew
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(controller)
            }
        }
    }
}
