//
//  Label.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/16/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Foundation
import BrewExtension

struct Label: LabelProtocol {

    fileprivate var _label: CDLabel
    
    init(label: CDLabel) {
        _label = label
    }

    var name: String {
        get { return _label.name ?? "" }
        set { _label.name = newValue }
    }

    var numberOfFormulaes: Int {
        return _label.formulaes?.count ?? 0
    }

    static func == (lhs: Label, rhs: Label) -> Bool {
        return lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
