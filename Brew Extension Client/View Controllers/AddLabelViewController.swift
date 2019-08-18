//
//  AddLabelViewController.swift
//  Brew Extension Client
//
//  Created by Zehua Chen on 8/14/19.
//  Copyright © 2019 Zehua Chen. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class AddLabelViewController: NSViewController {
    
    @IBOutlet weak var labelField: NSTextField!
    @IBOutlet weak var errorMessageField: NSTextField!
    @IBOutlet weak var addButton: NSButton!
    
    fileprivate var _cache = AppDelegate.sharedCache
    fileprivate var _disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        labelField.rx.text
            .map({ [unowned self] label in
                if label != nil {
                    if self._cache.containsLabel(label!) {
                        return "This name is already taken"
                    }
                }

                return ""
            })
            .bind(to: errorMessageField.rx.text).disposed(by: _disposeBag)

        labelField.rx.text
            .map({ [unowned self] label -> Bool in
                guard label != nil else { return false }
                guard !label!.isEmpty else { return false }
                guard !self._cache.containsLabel(label!) else { return false }

                return true
            }).bind(to: addButton.rx.isEnabled).disposed(by: _disposeBag)
    }
    
    @IBAction func onAddLabelClick(_ sender: Any) {
        _cache.addLabel(labelField.stringValue)
        self.presentingViewController?.dismiss(self)
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.presentingViewController?.dismiss(self)
    }
}
