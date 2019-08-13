//
//  CoreDataManager.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/13/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Foundation
import CoreData
import AppKit

class CoreDataManager {
    struct PersistentStore: OptionSet {
        typealias RawValue = Int
        let rawValue: Int

        static let sql = PersistentStore(rawValue: 1)
        static let inMemory = PersistentStore(rawValue: 2)
    }

    lazy var managedDataModel: NSManagedObjectModel = {
        guard let url = Bundle.main.url(
            forResource: self.managedDataModelName,
            withExtension: "momd") else {
            fatalError("Incorrect managed data model url")
        }

        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load managed data model")
        }

        return model
    }()

    lazy var viewContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator

        return context
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator

        return context
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedDataModel)

        if self.persistentStores.contains(.sql) {
            let sqlURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(Bundle.main.infoDictionary!["CFBundleName"] as! String)
                .appendingPathComponent("\(self.managedDataModelName).sqlite")

            do {
                try coordinator.addPersistentStore(
                    ofType: NSSQLiteStoreType,
                    configurationName: nil,
                    at: sqlURL,
                    options: nil)
            } catch {
                fatalError("Failed to add sql store")
            }
        }

        if self.persistentStores.contains(.inMemory) {
            do {
                try coordinator.addPersistentStore(
                    ofType: NSInMemoryStoreType,
                    configurationName: "",
                    at: nil,
                    options: nil)
            } catch {
                fatalError("Failed to add in-memory store")
            }
        }

        return coordinator
    }()

    let managedDataModelName: String
    let persistentStores: PersistentStore

    init(managedDataModelName: String, persistentStores: PersistentStore) {
        self.managedDataModelName = managedDataModelName
        self.persistentStores = persistentStores
    }

    static var managerForApplication: CoreDataManager = {
        return CoreDataManager(managedDataModelName: "BrewExtensionClient", persistentStores: .sql)
    }()

    static var managerForTesting: CoreDataManager = {
        return CoreDataManager(managedDataModelName: "BrewExtensionClient", persistentStores: .inMemory)
    }()
}
