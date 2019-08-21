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
        let relay = BehaviorRelay<Set<BECLabel>>(value: self.labels as! Set<BECLabel>)
        return relay
    }()

    lazy var obserableIsProtected: BehaviorRelay<Bool> = {
        let relay = BehaviorRelay<Bool>(value: self.isProtected)
        return relay
    }()
}
