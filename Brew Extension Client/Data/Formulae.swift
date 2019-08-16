//
//  Formulae.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/16/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Foundation
import BrewExtension

struct Formulae: FormulaeProtocol {
    fileprivate var _formulae: CDFormulae
    
    init(formulae: CDFormulae) {
        _formulae = formulae
    }

    var name: String {
        get { return _formulae.name ?? "" }
        set { _formulae.name = newValue }
    }

    var isProtected: Bool {
        get { return _formulae.isProtected }
        set { return _formulae.isProtected = newValue }
    }

    static func == (lhs: Formulae, rhs: Formulae) -> Bool {
        return lhs.name == rhs.name && lhs.isProtected == rhs.isProtected
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
        hasher.combine(self.isProtected)
    }
}
