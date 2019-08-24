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
    var formulaesSynced: PublishRelay<Void> = .init()
    var labels: BehaviorRelay<[BECLabel]> = .init(value: [])
    var formulaesCount: BehaviorRelay<Int> = .init(value: 0)

    var selectedLabel: BECLabel?
    var selectedFormulaes: BehaviorRelay<[BECFormulae]> = .init(value: [])
    var selectedFormulae: BehaviorRelay<BECFormulae?> = .init(value: nil)

    fileprivate var _bag: DisposeBag = DisposeBag()

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        self.selectedFormulaes
            .map({ formulaes -> BECFormulae? in
                if formulaes.isEmpty {
                    return nil
                }

                return formulaes[0]
            })
            .bind(to: self.selectedFormulae)
            .disposed(by: _bag)

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
        selectedLabel = label

        if selectedLabel != nil {
            self.selectedFormulaes.accept(self.fetchFormulaes(in: selectedLabel!))
        } else {
            self.selectedFormulaes.accept(self.fetchFormulaes())
        }
    }

    func selectFormulae(_ formulae: BECFormulae?) {
        self.selectedFormulae.accept(formulae)
    }
}
