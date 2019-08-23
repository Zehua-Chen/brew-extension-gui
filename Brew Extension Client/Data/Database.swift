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

class Database {

    struct BrewExtensionDataSourceWrapper: DataSource {
        func formulaes() -> [String] {
            return .init()
        }

        func outcomingDependencies(for formulaeName: String) -> Set<String> {
            return .init()
        }

        func protectsFormulae(_ name: String) -> Bool {
            return false
        }

        func labels(of formulaeName: String) -> Set<String> {
            return .init()
        }

        mutating func removeLabel(_ labelName: String, from formulaeName: String) {
        }

        mutating func removeFormulae(_ name: String) {
        }

        func containsFormulae(_ name: String) -> Bool {
            return false
        }

        func containsDependency(from sourceName: String, to targetName: String) -> Bool {
            return false
        }

        mutating func addFormulae(_ name: String) {
        }

        mutating func addDependency(from sourceName: String, to targetName: String) {

        }


    }

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchLabels(with properties: [String] = ["name"]) -> [BECLabel] {
        let labelsFetchRequest: NSFetchRequest<BECLabel> = BECLabel.fetchRequest()
        labelsFetchRequest.propertiesToFetch = properties
        labelsFetchRequest.sortDescriptors = [
            .init(keyPath: \BECLabel.name, ascending: true)
        ]

        return try! self.context.fetch(labelsFetchRequest)
    }

    func fetchFormulaes() -> [BECFormulae] {
        let formulaeFetchRequest: NSFetchRequest<BECFormulae> = BECFormulae.fetchRequest()
        formulaeFetchRequest.propertiesToFetch = ["name"]
        formulaeFetchRequest.sortDescriptors = [
            .init(key: "name", ascending: true)
        ]

        return try! self.context.fetch(formulaeFetchRequest)
    }

    func fetchFormulaes(in label: BECLabel) -> [BECFormulae] {
        let formulaeFetchRequest: NSFetchRequest<BECFormulae> = BECFormulae.fetchRequest()
        formulaeFetchRequest.sortDescriptors = [
            .init(key: "name", ascending: true)
        ]

        return try! self.context.fetch(formulaeFetchRequest).filter({ formulae in
            formulae.labels!.contains(label)
        })
    }

    func fetchFormulaesCount() -> Int {
        return try! self.context.count(for: BECFormulae.fetchRequest())
    }

    func deleteLabel(_ label: BECLabel) {
        self.context.delete(label)
        try! self.context.save()
    }

    func addLabel(_ label: String) {
        let l = BECLabel(context: self.context)
        l.name = label

        try! self.context.save()
    }

//    func labels(of formulae: String) -> Set<String> {
//        let formulaeFetchRequest: NSFetchRequest<BECFormulae> = BECFormulae.fetchRequest()
//        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)
//
//        let formulaes = try! self.context.fetch(formulaeFetchRequest)
//
//        return Set(formulaes[0].labels!.lazy.map { label in
//            return (label as! BECLabel).name!
//        })
//    }
//
//    func labels() -> [BECLabel] {
//        let labelFetchRequest: NSFetchRequest<BECLabel> = BECLabel.fetchRequest()
//        labelFetchRequest.propertiesToFetch = ["name"]
//        labelFetchRequest.sortDescriptors = [
//            .init(key: "name", ascending: true)
//        ]
//
//        labelFetchRequest.returnsDistinctResults = true
//
//        return try! self.context.fetch(labelFetchRequest)
//    }
//
//    func formulaes(under label: String) -> Set<BECFormulae> {
//        let labelFetchRequest: NSFetchRequest<BECLabel> = BECLabel.fetchRequest()
//        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)
//
//        let labels = try! self.context.fetch(labelFetchRequest)
//        guard labels.count == 1 else { return .init() }
//
//        return Set(labels[0].formulaes!.lazy.map{ formulae in
//            return (formulae as! BECFormulae)
//        })
//    }
//
//    func removeLabel(_ label: String, from formulae: String) {
//        let labelFetchRequest: NSFetchRequest<BECLabel> = BECLabel.fetchRequest()
//        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)
//
//        let labels = try! self.context.fetch(labelFetchRequest)
//
//        guard labels.count == 1 else { return }
//
//        let formulaeFetchRequest: NSFetchRequest<BECFormulae> = BECFormulae.fetchRequest()
//        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)
//
//        let formulaes = try! self.context.fetch(formulaeFetchRequest)
//
//        guard formulaes.count == 1 else { return }
//
//        formulaes[0].removeFromLabels(labels[0])
//        labels[0].removeFromFormulaes(formulaes[0])
//    }
//
//    func addLabel(_ label: String, to formulae: String) {
//        let labelFetchRequest: NSFetchRequest<BECLabel> = BECLabel.fetchRequest()
//        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)
//
//        let labels = try! self.context.fetch(labelFetchRequest)
//
//        guard labels.count == 1 else { return }
//
//        let formulaeFetchRequest: NSFetchRequest<BECFormulae> = BECFormulae.fetchRequest()
//        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)
//
//        let formulaes = try! self.context.fetch(formulaeFetchRequest)
//
//        guard formulaes.count == 1 else { return }
//
//        formulaes[0].addToLabels(labels[0])
//    }
//

//
//    func removeLabel(_ label: String) {
//        let labelFetchRequest: NSFetchRequest<BECLabel> = BECLabel.fetchRequest()
//        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)
//
//        let labels = try! self.context.fetch(labelFetchRequest)
//
//        guard labels.count == 1 else { return }
//
//        self.context.delete(labels[0] as NSManagedObject)
//    }
//
//    func containsLabel(_ label: String) -> Bool {
//        let labelFetchRequest: NSFetchRequest<BECLabel> = BECLabel.fetchRequest()
//        labelFetchRequest.predicate = NSPredicate(format: "name == %@", label)
//
//        let labels = try! self.context.fetch(labelFetchRequest)
//
//        return !labels.isEmpty
//    }
//
//    func protectFormulae(_ formulae: String) {
//        let formulaeFetchRequest: NSFetchRequest<BECFormulae> = BECFormulae.fetchRequest()
//        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)
//
//        let formulaes = try! self.context.fetch(formulaeFetchRequest)
//
//        guard formulaes.count == 1 else { return }
//
//        formulaes[0].isProtected = true
//    }
//
//    func protectsFormulae(_ formulae: String) -> Bool {
//        let formulaeFetchRequest: NSFetchRequest<BECFormulae> = BECFormulae.fetchRequest()
//        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)
//
//        let formulaes = try! self.context.fetch(formulaeFetchRequest)
//
//        guard formulaes.count == 1 else { return false }
//
//        return formulaes[0].isProtected
//    }
//
//    func unprotectFormulae(_ formulae: String) {
//        let formulaeFetchRequest: NSFetchRequest<BECFormulae> = BECFormulae.fetchRequest()
//        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)
//
//        let formulaes = try! self.context.fetch(formulaeFetchRequest)
//
//        guard !formulaes.isEmpty else { return }
//
//        formulaes[0].isProtected = false
//    }
//
//    func containsFormulae(_ formulae: String) -> Bool {
//        let formulaeFetchRequest: NSFetchRequest<BECFormulae> = BECFormulae.fetchRequest()
//        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)
//
//        let formulaes = try! self.context.fetch(formulaeFetchRequest)
//
//        return formulaes.count == 1
//    }
//
//    func addFormulae(_ formulae: String) {
//        let f = BECFormulae(context: self.context)
//        f.name = formulae
//    }
//
//    func removeFormulae(_ formulae: String) {
//        let formulaeFetchRequest: NSFetchRequest<BECFormulae> = BECFormulae.fetchRequest()
//        formulaeFetchRequest.predicate = NSPredicate(format: "name == %@", formulae)
//
//        let formulae = try! self.context.fetch(formulaeFetchRequest)[0]
//        self.context.delete(formulae as NSManagedObject)
//    }
//

//
//    func numberOfFormulaes() -> Int {
//        return self.formulaes().count
//    }
//
//    func addDependency(from: String, to: String) {
//        let from = _fetchFormlae(from)
//        let to = _fetchFormlae(to)
//
//        from.addToOutcomings(to)
//    }
//
//    func containsDependency(from: String, to: String) -> Bool {
//        let from = _fetchFormlae(from)
//        let to = _fetchFormlae(to)
//
//        return from.outcomings!.contains(to)
//    }
//
//    func outcomingDependencies(for formulae: String) -> Set<String> {
//        let formulae = _fetchFormlae(formulae)
//
//        return Set(formulae.outcomings!.lazy.map{ formulae in
//            return (formulae as! BECFormulae).name!
//        })
//    }
//
//    func incomingDependencies(for formulae: String) -> Set<String> {
//        let formulae = _fetchFormlae(formulae)
//
//        return Set(formulae.incomings!.lazy.map{ formulae in
//            return (formulae as! BECFormulae).name!
//        })
//    }
//
//    func write() {
//        try! self.context.save()
//    }
//
//    fileprivate func _fetchFormlae(
//        _ formulae: String,
//        with properties: [String] = []
//    ) -> BECFormulae {
//        let formulaeRequest: NSFetchRequest<BECFormulae> = BECFormulae.fetchRequest()
//        formulaeRequest.predicate = NSPredicate(format: "name == %@", formulae)
//        formulaeRequest.propertiesToFetch = properties
//
//        let formulaes = try! self.context.fetch(formulaeRequest)
//
//        guard formulaes.count == 1 else {
//            fatalError("Duplicate formulae = \(formulae)")
//        }
//
//        return formulaes[0]
//    }
//
//    fileprivate func _fetchLabel(
//        _ label: String,
//        with properties: [String] = []
//    ) -> BECLabel {
//        let labelRequest: NSFetchRequest<BECLabel> = BECLabel.fetchRequest()
//        labelRequest.predicate = NSPredicate(format: "name == %@", label)
//        labelRequest.propertiesToFetch = properties
//
//        let labels = try! self.context.fetch(labelRequest)
//
//        guard labels.count == 1 else {
//            fatalError("Duplicate label = \(label)")
//        }
//
//        return labels[0]
//    }
}
