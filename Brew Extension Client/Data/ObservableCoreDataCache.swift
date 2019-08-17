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
    var formulaes = BehaviorRelay<[Formulae]>(value: [])

    // MARK: Current Selection Related

    var currentLabel = BehaviorSubject<Label?>(value: nil)
    var currentFormulaes = BehaviorSubject<[Formulae]>(value: .init())
    var currentFormulae = BehaviorSubject<Formulae?>(value: nil)
    var currentFormulaeProtected = BehaviorSubject<Bool>(value: false)
    var currentFormulaeOutcomingDependencies = BehaviorSubject<[Formulae]>(value: [])
    var currentFormulaeIncomingDependencies = BehaviorSubject<[Formulae]>(value: [])

    fileprivate var _disposeBag = DisposeBag()

    override init(context: NSManagedObjectContext) {
        super.init(context: context)

        self.currentFormulae.map { [unowned self] formulae -> [Formulae] in
            guard formulae != nil else { return [] }
            return Array(self.outcomingDependencies(for: formulae!.name))
        }.subscribe(self.currentFormulaeOutcomingDependencies).disposed(by: _disposeBag)

        self.currentFormulae.map { [unowned self] formulae -> [Formulae] in
            guard formulae != nil else { return [] }
            return Array(self.incomingDependencies(for: formulae!.name))
        }.subscribe(self.currentFormulaeIncomingDependencies).disposed(by: _disposeBag)

        self.currentFormulae.map { formulae -> Bool in
            return formulae?.isProtected ?? false
        }.subscribe(self.currentFormulaeProtected).disposed(by: _disposeBag)

        self.currentFormulaes.map { formulaes -> Formulae? in
            guard !formulaes.isEmpty else { return nil }
            return formulaes[0]
        }.subscribe(self.currentFormulae).disposed(by: _disposeBag)

        self.currentLabel.map { [unowned self] label -> [Formulae] in
            if label == nil {
                return self.formulaes()
            }

            return Array(self.formulaes(under: label!.name))
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

    func unprotectFormulae(_ formulae: inout Formulae) {
        formulae.isProtected = false
        _updateCurrentFormulaeProtected(with: formulae.name, protection: formulae.isProtected)
    }

    func protectFormulae(_ formulae: inout Formulae) {
        formulae.isProtected = true
        _updateCurrentFormulaeProtected(with: formulae.name, protection: formulae.isProtected)
    }

    override func protectFormulae(_ formulae: String) {
        super.protectFormulae(formulae)
        _updateCurrentFormulaes()
    }

    override func unprotectFormulae(_ formulae: String) {
        super.unprotectFormulae(formulae)
        _updateCurrentFormulaes()
    }

    fileprivate func _updateCurrentFormulaeProtected(with formulae: String, protection: Bool) {
        if let currentFormulaeName = (try! self.currentFormulae.value())?.name {
            if formulae == currentFormulaeName {
                self.currentFormulaeProtected.onNext(protection)
            }
        }
    }

    fileprivate func _updateCurrentFormulaes() {
        if let labelName = (try! self.currentLabel.value())?.name {
            currentFormulaes.onNext(Array(self.formulaes(under: labelName)))
            return
        }

        currentFormulaes.onNext(self.formulaes())
    }

    func finishSync() {
        _updateCurrentFormulaes()
    }
}
