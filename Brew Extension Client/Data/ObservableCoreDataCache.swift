//
//  ObservableCoreDataCache.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/16/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import RxSwift
import RxCocoa

class ObservableCoreDataCache: CoreDataCache {
    fileprivate var _labels = BehaviorRelay<[Label]>(value: [])

    var labels: Observable<[Label]> {
        return _labels.asObservable()
    }

    override init(context: NSManagedObjectContext) {
        super.init(context: context)
    }

    override func addLabel(_ label: String) {
        super.addLabel(label)
        _labels.accept(self.labels())
    }

    override func removeLabel(_ label: String) {
        super.removeLabel(label)
        _labels.accept(self.labels())
    }
}
