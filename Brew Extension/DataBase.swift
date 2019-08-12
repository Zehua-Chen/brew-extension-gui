//
//  DataBase.swift
//  Brew Extension
//
//  Created by Zehua Chen on 8/13/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Foundation
import BrewExtension

class DataBase: GraphBasedBrewExtensionDataBase {
    var formulaes = Graph<String, FormulaeInfo>()
    var labels = [String : Set<String>]()

    var url: URL

    init() {
//        let package = Bundle.main.url
    }

    func write() {
    }
}
