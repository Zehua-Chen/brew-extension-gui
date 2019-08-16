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

class CoreDataCache: Cache {

    struct Label: LabelProtocol {

        fileprivate var _label: CDLabel
        fileprivate init(label: CDLabel) {
            _label = label
        }

        var name: String {
            get { return _label.name ?? "" }
            set { _label.name = newValue }
        }

        static func == (lhs: CoreDataCache.Label, rhs: CoreDataCache.Label) -> Bool {
            return lhs.name == rhs.name
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(self.name)
        }
    }

    struct Formulae: FormulaeProtocol {
        fileprivate var _formulae: CDFormulae
        fileprivate init(formulae: CDFormulae) {
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

        static func == (lhs: CoreDataCache.Formulae, rhs: CoreDataCache.Formulae) -> Bool {
            return lhs.name == rhs.name && lhs.isProtected == rhs.isProtected
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(self.name)
            hasher.combine(self.isProtected)
        }
    }

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func labels(of formulae: String) -> Set<Label> {
        let formulaeFetchRequest: NSFetchRequest<CDFormulae> = CDFormulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! self.context.fetch(formulaeFetchRequest)

        return Set(formulaes[0].labels!.lazy.map { label in
            return Label(label: label as! CDLabel)
        })
    }

    func labels() -> [Label] {
        let labelFetchRequest: NSFetchRequest<CDLabel> = CDLabel.fetchRequest()
        labelFetchRequest.propertiesToFetch = ["name"]
        labelFetchRequest.returnsDistinctResults = true

        return try! self.context.fetch(labelFetchRequest).map { label in
            return Label(label: label)
        }
    }

    func formulaes(under label: String) -> Set<Formulae> {
        let labelFetchRequest: NSFetchRequest<CDLabel> = CDLabel.fetchRequest()
        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)

        let labels = try! self.context.fetch(labelFetchRequest)
        guard labels.count == 1 else { return .init() }

        return Set(labels[0].formulaes!.lazy.map{ formulae in
            return Formulae(formulae: (formulae as! CDFormulae))
        })
    }

    func removeLabel(_ label: String, from formulae: String) {
        let labelFetchRequest: NSFetchRequest<CDLabel> = CDLabel.fetchRequest()
        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)

        let labels = try! self.context.fetch(labelFetchRequest)

        guard labels.count == 1 else { return }

        let formulaeFetchRequest: NSFetchRequest<CDFormulae> = CDFormulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! self.context.fetch(formulaeFetchRequest)

        guard formulaes.count == 1 else { return }

        formulaes[0].removeFromLabels(labels[0])
        labels[0].removeFromFormulaes(formulaes[0])
    }

    func addLabel(_ label: String, to formulae: String) {
        let labelFetchRequest: NSFetchRequest<CDLabel> = CDLabel.fetchRequest()
        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)

        let labels = try! self.context.fetch(labelFetchRequest)

        guard labels.count == 1 else { return }

        let formulaeFetchRequest: NSFetchRequest<CDFormulae> = CDFormulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! self.context.fetch(formulaeFetchRequest)

        guard formulaes.count == 1 else { return }

        formulaes[0].addToLabels(labels[0])
    }

    func addLabel(_ label: String) {
        let l = CDLabel(context: self.context)
        l.name = label
    }

    func removeLabel(_ label: String) {
        let labelFetchRequest: NSFetchRequest<CDLabel> = CDLabel.fetchRequest()
        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)

        let labels = try! self.context.fetch(labelFetchRequest)

        guard labels.count == 1 else { return }
        
        self.context.delete(labels[0] as NSManagedObject)
    }

    func containsLabel(_ label: String) -> Bool {
        let labelFetchRequest: NSFetchRequest<CDLabel> = CDLabel.fetchRequest()
        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)

        let labels = try! self.context.fetch(labelFetchRequest)

        return !labels.isEmpty
    }

    func protectFormulae(_ formulae: String) {
        let formulaeFetchRequest: NSFetchRequest<CDFormulae> = CDFormulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! self.context.fetch(formulaeFetchRequest)

        guard formulaes.count == 1 else { return }

        formulaes[0].isProtected = true
    }

    func protectsFormulae(_ formulae: String) -> Bool {
        let formulaeFetchRequest: NSFetchRequest<CDFormulae> = CDFormulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! self.context.fetch(formulaeFetchRequest)

        guard formulaes.count == 1 else { return false }

        return formulaes[0].isProtected
    }

    func unprotectFormulae(_ formulae: String) {
        let formulaeFetchRequest: NSFetchRequest<CDFormulae> = CDFormulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! self.context.fetch(formulaeFetchRequest)

        guard !formulaes.isEmpty else { return }

        formulaes[0].isProtected = false
    }

    func containsFormulae(_ formulae: String) -> Bool {
        let formulaeFetchRequest: NSFetchRequest<CDFormulae> = CDFormulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulaes = try! self.context.fetch(formulaeFetchRequest)

        return formulaes.count == 1
    }

    func addFormulae(_ formulae: String) {
        let f = CDFormulae(context: self.context)
        f.name = formulae
    }

    func removeFormulae(_ formulae: String) {
        let formulaeFetchRequest: NSFetchRequest<CDFormulae> = CDFormulae.fetchRequest()
        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)

        let formulae = try! self.context.fetch(formulaeFetchRequest)[0]
        self.context.delete(formulae as NSManagedObject)
    }

    func formulaes() -> [Formulae] {
        let formulaeFetchRequest: NSFetchRequest<CDFormulae> = CDFormulae.fetchRequest()
        formulaeFetchRequest.propertiesToFetch = ["name"]

        return try! self.context.fetch(formulaeFetchRequest).map{ formulae in
            return Formulae(formulae: formulae)
        }
    }

    func addDependency(from: String, to: String) {
        let from = _fetchFormlae(from)
        let to = _fetchFormlae(to)

        from.addToOutcomings(to)
    }

    func containsDependency(from: String, to: String) -> Bool {
        let from = _fetchFormlae(from)
        let to = _fetchFormlae(to)

        return from.outcomings!.contains(to)
    }

    func outcomingDependencies(for formulae: String) -> Set<Formulae> {
        let formulae = _fetchFormlae(formulae)

        return Set(formulae.outcomings!.lazy.map{ formulae in
            return Formulae(formulae: (formulae as! CDFormulae))
        })
    }

    func incomingDependencies(for formulae: String) -> Set<Formulae> {
        let formulae = _fetchFormlae(formulae)

        return Set(formulae.incomings!.lazy.map{ formulae in
            return Formulae(formulae: (formulae as! CDFormulae))
        })
    }

    func write() {
        try! self.context.save()
    }

    fileprivate func _fetchFormlae(
        _ formulae: String,
        with properties: [String] = []
    ) -> CDFormulae {
        let formulaeRequest: NSFetchRequest<CDFormulae> = CDFormulae.fetchRequest()
        formulaeRequest.predicate = NSPredicate(format: "name == %@", formulae)
        formulaeRequest.propertiesToFetch = properties

        let formulaes = try! self.context.fetch(formulaeRequest)

        guard formulaes.count == 1 else {
            fatalError("Duplicate formulae = \(formulae)")
        }

        return formulaes[0]
    }
}
