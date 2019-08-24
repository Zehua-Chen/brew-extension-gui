//
//  NSUserInterfaceItemIdentifierExtension.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/23/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa

extension NSUserInterfaceItemIdentifier {
    static var labelCellView: NSUserInterfaceItemIdentifier {
        return .init("labelCellView")
    }

    static var incomingDepsCellView: NSUserInterfaceItemIdentifier {
        return .init("incomingDepsCellView")
    }

    static var outcomingDepsCellView: NSUserInterfaceItemIdentifier {
        return .init("outcomingDepsCellView")
    }

    static var formulaeCellView: NSUserInterfaceItemIdentifier {
        return .init("formulaeCellView")
    }

    static var outcomingDepsColum: NSUserInterfaceItemIdentifier {
        return .init("outcomingDepsColum")
    }

    static var incomingDepsColum: NSUserInterfaceItemIdentifier {
        return .init("incomingDepsColum")
    }

}
