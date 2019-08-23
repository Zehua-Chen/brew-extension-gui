//
//  ObservableCoreDataCache.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/16/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import RxSwift
import RxCocoa

class ObservableDatabase: Database {
    var sync: PublishRelay<Void> = .init()
    var labels: BehaviorRelay<[BECLabel]> = .init(value: [])
    var formulaesCount: BehaviorRelay<Int> = .init(value: 0)

    var currentFormulaes: BehaviorRelay<[BECFormulae]> = .init(value: [])
    var currentFormulae: BehaviorRelay<BECFormulae?> = .init(value: nil)

    fileprivate var _bag: DisposeBag = DisposeBag()
    fileprivate var _selectedLabel: BECLabel?

    override init(context: NSManagedObjectContext) {
        super.init(context: context)
        self.labels.accept(self.fetchLabels())
        self.formulaesCount.accept(self.fetchFormulaesCount())
    }

    override func addLabel(_ label: String) {
        super.addLabel(label)
        self.labels.accept(self.fetchLabels())
    }

    override func deleteLabel(_ label: BECLabel) {
        super.deleteLabel(label)
        self.labels.accept(self.fetchLabels())
    }

    func selectLabel(_ label: BECLabel?) {
        _selectedLabel = label
        self.currentFormulaes.accept(self.fetchFormulaes())
    }

    func selectFormulae(_ formulae: BECFormulae?) {
        self.currentFormulae.accept(formulae)
    }
}
