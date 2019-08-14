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

/// An instance of a `CoreDataManager` represents the a unique "Core
/// Data" database
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
            let fileManager = FileManager.default

            var sqlURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(Bundle.main.infoDictionary!["CFBundleName"] as! String)

            if !fileManager.fileExists(atPath: sqlURL.path) {
                try! fileManager.createDirectory(at: sqlURL, withIntermediateDirectories: false, attributes: nil)
            }

            sqlURL.appendPathComponent("\(self.managedDataModelName).sqlite")

            if !fileManager.fileExists(atPath: sqlURL.path) {
                let result = fileManager.createFile(atPath: sqlURL.path, contents: nil, attributes: nil)
            }

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

    /// A shared data manager across the application
    static var shared: CoreDataManager = {
        return CoreDataManager(managedDataModelName: "BrewExtensionClient", persistentStores: .sql)
    }()

    /// Construct a new manager for testing purpose
    ///
    /// - Returns: a new core data manager
    static func makeManagerForTesting() -> CoreDataManager {
        return CoreDataManager(managedDataModelName: "BrewExtensionClient", persistentStores: .inMemory)
    }
}
