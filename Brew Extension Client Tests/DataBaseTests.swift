//
//  DataBaseTests.swift
//  Brew Extension Client Tests
//
//  Created by Zehua Chen on 8/23/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import XCTest
@testable import BrewExtensionClient

class DataBaseTests: XCTestCase {
    func testFetchFormulaeWithName() {
        let manager = CoreDataManager.makeManagerForTesting()
        let database = Database(context: manager.viewContext)

        let f = BECFormulae(context: manager.viewContext)
        f.name = "target"

        let fetched = database.fetchFormulae(with: "target")

        XCTAssertNotNil(fetched.name)
        XCTAssertEqual(fetched.name!, "target")
    }
}
