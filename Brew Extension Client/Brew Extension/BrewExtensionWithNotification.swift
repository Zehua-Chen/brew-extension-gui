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
}


class BrewExtensionWithNotification: BrewExtension {
    var notificationCenter = NotificationCenter.default

    override func addLabel(_ label: String) {
        super.addLabel(label)
        self.notificationCenter.post(.makeLabelsAddedNotification())
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
}
