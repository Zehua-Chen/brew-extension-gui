//
//  Label.swift
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

    func containsFormulae(_ formulae: Formulae) -> Bool {
        return _label.formulaes?.contains(formulae._formulae) ?? false
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
