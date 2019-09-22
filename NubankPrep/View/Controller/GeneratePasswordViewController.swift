//
//  GeneratePasswordViewController.swift
//  NubankPrep
//
//  Created by Gabriel Araujo on 21/09/19.
//  Copyright © 2019 Gabriel Araujo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GeneratePasswordViewController: UIViewController {
    
    let bag = DisposeBag()
    
    let mainView: GeneratePasswordView
    let viewModel: GeneratePasswordViewModel

    init() {
        let view = GeneratePasswordView()
        
        let uppercase = view.optionUpperCase.switchControl.rx.value.asObservable()
        let digits = view.optionDigits.switchControl.rx.value.asObservable()
        let special = view.optionSpecialCharacters.switchControl.rx.value.asObservable()
        
        viewModel = GeneratePasswordViewModel(
            passwordLength: view.sliderLength.rx.value.asObservable(),
            selectedUppercase: uppercase,
            selectedContainsDigits: digits,
            selectedSpecialCharacters: special,
            tappedGenerate: view.btnGenerate.rx.tap.asObservable()
        )
        
        self.mainView = view
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bindUI()
    }
    
    func bindUI() {
        viewModel.selectedLength
            .drive(self.mainView.rx.sliderValue)
            .disposed(by: bag)
        
        viewModel.state
            .drive(self.mainView.rx.state)
            .disposed(by: bag)
    }
    
}
