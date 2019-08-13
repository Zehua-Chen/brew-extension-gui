//
//  ViewController.swift
//  Brew Extension
//
//  Created by Zehua Chen on 8/13/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

//    let dataBase = DataBase(context: AppDelegate.viewContext)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let m = CoreDataManager.managerForApplication
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

