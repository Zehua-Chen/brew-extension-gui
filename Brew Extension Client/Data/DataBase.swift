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
        let formulaeFetchRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! self.context.fetch(formulaeFetchRequest)

        return Set(formulaes[0].labels!.lazy.map { return ($0 as! Label).name! })
    }

    func labels() -> [String] {
        let labelFetchRequest: NSFetchRequest<Label> = Label.fetchRequest()
        labelFetchRequest.propertiesToFetch = ["name"]
        labelFetchRequest.returnsDistinctResults = true

        return try! self.context.fetch(labelFetchRequest).map { label in
            return label.name!
        }
    }

    func formulaes(under label: String) -> Set<String> {
        let labelFetchRequest: NSFetchRequest<Label> = Label.fetchRequest()
        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)

        let labels = try! self.context.fetch(labelFetchRequest)
        guard labels.count == 1 else { return .init() }

        return Set(labels[0].formulaes!.lazy.map{ return ($0 as! Formulae).name! })
    }

    func removeLabel(_ label: String, from formulae: String) {
        let labelFetchRequest: NSFetchRequest<Label> = Label.fetchRequest()
        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)

        let labels = try! self.context.fetch(labelFetchRequest)

        guard labels.count == 1 else { return }

        let formulaeFetchRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! self.context.fetch(formulaeFetchRequest)

        guard formulaes.count == 1 else { return }

        formulaes[0].removeFromLabels(labels[0])
        labels[0].removeFromFormulaes(formulaes[0])
    }

    func addLabel(_ label: String, to formulae: String) {
        let labelFetchRequest: NSFetchRequest<Label> = Label.fetchRequest()
        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)

        let labels = try! self.context.fetch(labelFetchRequest)

        guard labels.count == 1 else { return }

        let formulaeFetchRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! self.context.fetch(formulaeFetchRequest)

        guard formulaes.count == 1 else { return }

        formulaes[0].addToLabels(labels[0])
    }

    func addLabel(_ label: String) {
        let l = Label(context: self.context)
        l.name = label
    }

    func removeLabel(_ label: String) {
        let labelFetchRequest: NSFetchRequest<Label> = Label.fetchRequest()
        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)

        let labels = try! self.context.fetch(labelFetchRequest)

        guard labels.count == 1 else { return }
        
        self.context.delete(labels[0] as NSManagedObject)
    }

    func containsLabel(_ label: String) -> Bool {
        let labelFetchRequest: NSFetchRequest<Label> = Label.fetchRequest()
        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)

        let labels = try! self.context.fetch(labelFetchRequest)

        return !labels.isEmpty
    }

    func protectFormulae(_ formulae: String) {
        let formulaeFetchRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! self.context.fetch(formulaeFetchRequest)

        guard formulaes.count == 1 else { return }

        formulaes[0].isProtected = true
    }

    func protectsFormulae(_ formulae: String) -> Bool {
        let formulaeFetchRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! self.context.fetch(formulaeFetchRequest)

        guard formulaes.count == 1 else { return false }

        return formulaes[0].isProtected
    }

    func unprotectFormulae(_ formulae: String) {
        let formulaeFetchRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! self.context.fetch(formulaeFetchRequest)

        guard !formulaes.isEmpty else { return }

        formulaes[0].isProtected = false
    }

    func containsFormulae(_ formulae: String) -> Bool {
        let formulaeFetchRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! self.context.fetch(formulaeFetchRequest)

        return formulaes.count == 1
    }

    func addFormulae(_ formulae: String) {
        let f = Formulae(context: self.context)
        f.name = formulae
    }

    func removeFormulae(_ formulae: String) {
        let formulaeFetchRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulae = try! self.context.fetch(formulaeFetchRequest)[0]
        self.context.delete(formulae as NSManagedObject)
    }

    func formulaes() -> [String] {
        let formulaeFetchRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        formulaeFetchRequest.propertiesToFetch = ["name"]

        return try! self.context.fetch(formulaeFetchRequest).map{ return $0.name! }
    }

    func addDependency(from: String, to: String) {
        let fromRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        fromRequest.predicate = NSPredicate(format: "name == %@", from)

        let froms = try! self.context.fetch(fromRequest)
        guard froms.count == 1 else { return }

        let toRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        toRequest.predicate = NSPredicate(format: "name == %@", to)

        let tos = try! self.context.fetch(toRequest)
        guard tos.count == 1 else { return }

        froms[0].addToOutcomings(tos[0])
    }

    func containsDependency(from: String, to: String) -> Bool {
        let fromRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        fromRequest.predicate = NSPredicate(format: "name == %@", from)

        let froms = try! self.context.fetch(fromRequest)
        guard froms.count == 1 else { return false }

        let toRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        toRequest.predicate = NSPredicate(format: "name == %@", to)

        let tos = try! self.context.fetch(toRequest)
        guard tos.count == 1 else { return false }

        return froms[0].outcomings!.contains(tos[0])
    }

    func outcomingDependencies(for formulae: String) -> Set<String> {
        let formulaeRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        formulaeRequest.predicate = NSPredicate(format: "name == %@", formulae)
        formulaeRequest.propertiesToFetch = ["name"]

        let formulaes = try! context.fetch(formulaeRequest)
        guard formulaes.count == 1 else { return .init() }

        return Set(formulaes[0].outcomings!.lazy.map{ return ($0 as! Formulae).name! })
    }

    func incomingDependencies(for formulae: String) -> Set<String> {
        let formulaeRequest: NSFetchRequest<Formulae> = Formulae.fetchRequest()
        formulaeRequest.predicate = NSPredicate(format: "name == %@", formulae)
        formulaeRequest.propertiesToFetch = ["name"]

        let formulaes = try! context.fetch(formulaeRequest)
        guard formulaes.count == 1 else { return .init() }

        return Set(formulaes[0].incomings!.lazy.map{ return ($0 as! Formulae).name! })
    }

    func write() {
        try! self.context.save()
    }
}
