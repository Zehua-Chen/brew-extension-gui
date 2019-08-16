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
    struct FormulaeUpdate {
        var formulaes = [Formulae]()
        var shouldAnimate = false
    }

    var labels = BehaviorRelay<[Label]>(value: [])

    // MARK: Current Selection Related

    var currentLabel = BehaviorSubject<Label?>(value: nil)
    var currentFormulaes = BehaviorSubject<FormulaeUpdate>(value: .init())

    fileprivate var _disposeBag = DisposeBag()

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        self.currentLabel.map { [unowned self] label -> FormulaeUpdate in
            if label == nil {
                return FormulaeUpdate(formulaes: self.formulaes(), shouldAnimate: false)
            }

            return FormulaeUpdate(formulaes: Array(self.formulaes(under: label!.name)), shouldAnimate: false)
        }.subscribe(self.currentFormulaes).disposed(by: _disposeBag)

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

    func finishSync() {
        if let labelName = (try! self.currentLabel.value())?.name {
            currentFormulaes.onNext(.init(
                formulaes: Array(self.formulaes(under: labelName)),
                shouldAnimate: true))
            return
        }

        currentFormulaes.onNext(.init(
            formulaes: self.formulaes(),
            shouldAnimate: true))
    }
}
