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
    var labels = BehaviorRelay<[Label]>(value: [])
    var currentLabel = BehaviorRelay<Label?>(value: nil)
    var onSync = BehaviorRelay<Void>(value: ())

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        self.labels.accept(self.labels())
    }

    override func addLabel(_ label: String) {
        super.addLabel(label)
        self.labels.accept(self.labels())
    }

    override func removeLabel(_ label: String) {
        super.removeLabel(label)
        self.labels.accept(self.labels())
    }

    func selectLabel(_ label: Label?) {
        self.currentLabel.accept(label)
    }
}
