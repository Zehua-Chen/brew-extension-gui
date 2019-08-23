//
//  BECLabel.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/19/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class BECLabel: NSManagedObject {
    lazy var observableFormulaesCount: BehaviorRelay<Int> = {
        return BehaviorRelay<Int>(value: self.formulaes?.count ?? 0)
    }()

    override func awakeFromFetch() {
        super.awakeFromFetch()
        _setupObservables()
    }

    override func awakeFromInsert() {
        super.awakeFromInsert()
        _setupObservables()
    }

    override func didChangeValue(
        forKey inKey: String,
        withSetMutation inMutationKind: NSKeyValueSetMutationKind,
        using inObjects: Set<AnyHashable>
    ) {
        super.didChangeValue(forKey: inKey, withSetMutation: inMutationKind, using: inObjects)

        switch inKey {
        case "formulaes":
            self.observableFormulaesCount.accept(self.formulaes!.count)
        default:
            break
        }
    }

    fileprivate func _setupObservables() {
        self.observableFormulaesCount.accept(self.formulaes?.count ?? 0)
    }
}
