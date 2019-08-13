//
//  DataBase.swift
//  Brew Extension
//
//  Created by Zehua Chen on 8/13/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Foundation
import BrewExtension
import CoreData

class DataBase: BrewExtensionDataBase {

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func labels(of formulae: String) -> Set<String> {
        return .init()
    }

    func labels() -> [String] {
        return []
    }

    func formulaes(under label: String) -> Set<String> {
        return .init()
    }

    func removeLabel(_ label: String, from formulae: String) {
        let labelFetchRequest: NSFetchRequest<Label> = Label.fetchRequest()
        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)

        let labels = try! labelFetchRequest.execute()

        guard !labels.isEmpty else { return }

        let formulaeFetchRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        labelFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! formulaeFetchRequest.execute()

        guard !formulaes.isEmpty else { return }

        formulaes[0].removeFromLabels(labels[0])
        labels[0].removeFromFormulaes(formulaes[0])


    }

    func addLabel(_ label: String, to formulae: String) {
        let labelFetchRequest: NSFetchRequest<Label> = Label.fetchRequest()
        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)

        let labels = try! labelFetchRequest.execute()

        guard !labels.isEmpty else { return }

        let formulaeFetchRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! formulaeFetchRequest.execute()

        guard !formulaes.isEmpty else { return }

        formulaes[0].addToLabels(labels[0])
        labels[0].addToFormulaes(formulaes[0])
    }

    func createLabel(_ label: String) {
        let l = Label(context: self.context)
        l.name = label
    }

    func removeLabel(_ label: String) {
        let labelFetchRequest: NSFetchRequest<Label> = Label.fetchRequest()
        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)

        let labels = try! labelFetchRequest.execute()
        
        self.context.delete(labels[0] as NSManagedObject)
    }

    func hasLabel(_ label: String) -> Bool {
        return false
    }

    func protectFormulae(_ formulae: String) {
    }

    func protectsFormulae(_ formulae: String) -> Bool {
        return false
    }

    func unprotectFormulae(_ formulae: String) {
    }

    func containsFormulae(_ formulae: String) -> Bool {
        return false
    }

    func addFormulae(_ formulae: String) {
    }

    func removeFormulae(_ formulae: String) {
    }

    func formulaes() -> [String] {
        return .init()
    }

    func addDependency(from: String, to: String) {
    }

    func hasDependency(from: String, to: String) -> Bool {
        return false
    }

    func outcomingDependencies(for formulae: String) -> Set<String> {
        return .init()
    }

    func incomingDependencies(for formulae: String) -> Set<String> {
        return .init()
    }


    deinit {
        self.write()
    }

    func write() {
        try! self.context.save()
    }
}
