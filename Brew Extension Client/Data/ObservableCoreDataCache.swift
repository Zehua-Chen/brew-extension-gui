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
    fileprivate var _selectedLabel = BehaviorRelay<Label?>(value: nil)

    var labels: Observable<[Label]> {
        return _labels.asObservable()
    }

    var selectedLabel: Observable<Label?> {
        return _selectedLabel.asObservable()
    }

    override init(context: NSManagedObjectContext) {
        super.init(context: context)
        _labels.accept(self.labels())
    }

    override func addLabel(_ label: String) {
        super.addLabel(label)
        _labels.accept(self.labels())
    }

    override func removeLabel(_ label: String) {
        super.removeLabel(label)
        _labels.accept(self.labels())
    }

    func selectLabel(_ label: Label?) {
        _selectedLabel.accept(label)
    }
}
