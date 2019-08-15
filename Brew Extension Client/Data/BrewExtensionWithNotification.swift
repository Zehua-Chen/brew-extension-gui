//
//  BrweExtensionWithNotification.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import BrewExtension
import Foundation

extension Notification.Name {
    static var labelsSelected = Notification.Name("labelsSelected")
    static var labelsAdded = Notification.Name("labelsAdded")
    static var labelsRemoved = Notification.Name("labelsRemoved")

    static var formulaeSelected = Notification.Name("formulaeSelected")
    static var formulaeProtectionChanged = Notification.Name("formulaeProtectionChanged")

    static var formulaeLabelChanged = Notification.Name("formulaeLabelChanged")

    static var findFormulaeToBeRemovedFor = Notification.Name("findFormulaeToBeRemovedFor")
}

extension Notification {
    static func makeLabelsAddedNotification() -> Notification {
        return .init(name: .labelsAdded, object: nil, userInfo: nil)
    }

    static func makeLabelsRemovedNotification() -> Notification {
        return .init(name: .labelsRemoved, object: nil, userInfo: nil)
    }

    static func makeLabelsSelectedNotification(label: String) -> Notification {
        return .init(name: .labelsSelected, object: nil, userInfo: ["label": label])
    }

    static func makeFormulaesSelectedNotification(formulae: String) -> Notification {
        return .init(name: .formulaeSelected, object: nil, userInfo: ["formulae": formulae])
    }

    static func makeFormulaeProtectionChangedNotification(formulae: String) -> Notification {
        return .init(name: .formulaeProtectionChanged, object: nil, userInfo: ["formulae": formulae])
    }

    static func makeFormulaeLabelChange(formulae: String) -> Notification {
        return .init(name: .formulaeLabelChanged, object: nil, userInfo: [
            "formulae": formulae,
        ])
    }

    static func makeFindFormulaesToBeRemovedFor(formulae: String, removes: [String]) -> Notification {
        return .init(name: .findFormulaeToBeRemovedFor, object: nil, userInfo: [
            "formulae": formulae,
            "removes": removes
        ])
    }
}


class BrewExtensionWithNotification: BrewExtension {
    var notificationCenter = NotificationCenter.default

    override func addLabel(_ label: String) {
        super.addLabel(label)
        self.notificationCenter.post(.makeLabelsAddedNotification())
    }

    override func labelFormulae(_ formulae: String, as label: String) throws {
        try super.labelFormulae(formulae, as: label)
        self.notificationCenter.post(.makeFormulaeLabelChange(formulae: formulae))
    }

    override func removeLabel(_ label: String, from formulae: String) throws {
        try super.removeLabel(label, from: formulae)
        self.notificationCenter.post(.makeFormulaeLabelChange(formulae: formulae))
    }

    override func removeLabel(_ label: String) throws {
        try super.removeLabel(label)
        self.notificationCenter.post(.makeLabelsRemovedNotification())
    }

    func selectLabel(_ label: String) {
        self.notificationCenter.post(.makeLabelsSelectedNotification(label: label))
    }

    func selectFormulae(_ formulae: String) {
        self.notificationCenter.post(.makeFormulaesSelectedNotification(formulae: formulae))
    }

    override func protectFormulae(_ formulae: String) {
        super.protectFormulae(formulae)
        self.notificationCenter.post(.makeFormulaeProtectionChangedNotification(formulae: formulae))
    }

    override func unprotectFormulae(_ formulae: String) {
        super.unprotectFormulae(formulae)
        self.notificationCenter.post(.makeFormulaeProtectionChangedNotification(formulae: formulae))
    }

    override func findFormulaesToUninstall(for formulae: String) -> [String] {
        let f = super.findFormulaesToUninstall(for: formulae)
        self.notificationCenter.post(.makeFindFormulaesToBeRemovedFor(formulae: formulae, removes: f))

        return f
    }
}