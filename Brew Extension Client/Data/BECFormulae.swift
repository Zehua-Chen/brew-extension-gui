//
//  BECFormulae.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/19/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

class BECFormulae: NSManagedObject {
    lazy var observalbleLabels: BehaviorRelay<Set<BECLabel>> = {
        return .init(value: self.labels as! Set<BECLabel>)
    }()

    lazy var obserableIsProtected: BehaviorRelay<Bool> = {
        let relay = BehaviorRelay<Bool>(value: self.isProtected)
        return relay
    }()

    var typedOutcomings: Set<BECFormulae> {
        return self.outcomings as! Set<BECFormulae>
    }

    var typedIncomings: Set<BECFormulae> {
        return self.incomings as! Set<BECFormulae>
    }

    var typedLabels: Set<BECLabel> {
        return self.labels as! Set<BECLabel>
    }

    override func didChangeValue(forKey key: String) {
        switch key {
        case "isProtected":
            self.obserableIsProtected.accept(self.isProtected)
        default:
            break
        }
    }

    override func didChangeValue(
        forKey inKey: String,
        withSetMutation inMutationKind: NSKeyValueSetMutationKind,
        using inObjects: Set<AnyHashable>
    ) {
        super.didChangeValue(forKey: inKey, withSetMutation: inMutationKind, using: inObjects)

        switch inKey {
        case "labels":
            self.observalbleLabels.accept(self.labels as! Set<BECLabel>)
        default:
            break
        }
    }

    fileprivate func _labelsAsArray() -> [BECLabel] {
        return Array(self.labels as! Set<BECLabel>)
    }
}
