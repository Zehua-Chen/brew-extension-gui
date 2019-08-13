//
//  DataBaseTests.swift
//  Brew Extension Client Tests
//
//  Created by Zehua Chen on 8/13/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import XCTest
@testable import BrewExtensionClient

class DataBaseTests: XCTestCase {

    func testFormulaes() {
        
    }

    func testLabels() {
        let manager = CoreDataManager.managerForTesting
        let database = DataBase(context: manager.viewContext)

        database.addLabel("life")
        XCTAssertTrue(database.containsLabel("life"))

        database.addLabel("cs241")
        XCTAssertTrue(database.containsLabel("cs241"))

        XCTAssertEqual(database.labels().count, 2)

        database.removeLabel("life")
        XCTAssertFalse(database.containsLabel("life"))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
