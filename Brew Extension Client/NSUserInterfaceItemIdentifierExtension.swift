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

    static var dependencyCellView: NSUserInterfaceItemIdentifier {
        return .init("dependencyCellView")
    }
}
