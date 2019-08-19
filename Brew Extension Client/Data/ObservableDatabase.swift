//
//  ObservableCoreDataCache.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/16/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import RxSwift
import RxCocoa

class ObservableDatabase: Database, ReactiveCompatible {
    var labels = BehaviorRelay<[BECLabel]>(value: [])
    var formulaesCount = BehaviorRelay<Int>(value: 0)

    var currentLabel = BehaviorRelay<BECLabel?>(value: nil)

    fileprivate var _bag = DisposeBag()

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        self.labels
            .map({ labels -> BECLabel? in
                guard !labels.isEmpty else { return nil }
                return labels[0]
            })
            .bind(to: self.currentLabel)
            .disposed(by: _bag)

        // TODO: Send the correct formulaes count
        self.labels
            .map({ return $0.count })
            .bind(to: self.formulaesCount)
            .disposed(by: _bag)

        self.labels.accept(self.fetchLabels())
    }

    override func addLabel(_ label: String) {
        super.addLabel(label)
        self.labels.accept(self.fetchLabels())
    }

    override func deleteLabel(_ label: BECLabel) {
        super.deleteLabel(label)
        self.labels.accept(self.fetchLabels())
    }
}
