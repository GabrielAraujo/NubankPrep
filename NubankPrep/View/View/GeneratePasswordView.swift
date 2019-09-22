//
//  GeneratePasswordView.swift
//  NubankPrep
//
//  Created by Gabriel Araujo on 21/09/19.
//  Copyright © 2019 Gabriel Araujo. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class GeneratePasswordView: UIView {
    
    let minLength: Float = 6.0
    
    let lblTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = view.font.withSize(22.0)
        view.textAlignment = .center
        view.text = "Generate a Password"
        return view
    }()
    
    let lblOptions: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = view.font.withSize(18.0)
        view.text = "Select the options bellow:"
        return view
    }()
    
    lazy var lblLength: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = view.font.withSize(16.0)
        view.textAlignment = .center
        view.text = "\(Int(self.minLength))"
        return view
    }()
    
    lazy var sliderLength: UISlider = {
        let view = UISlider(frame: .zero)
        view.minimumValue = self.minLength
        view.maximumValue = 50
        return view
    }()
    
    let optionUpperCase: PasswordOption = {
        let view = PasswordOption(title: "UpperCased?")
        return view
    }()
    
    let optionDigits: PasswordOption = {
        let view = PasswordOption(title: "Contains Digits?")
        return view
    }()

    let optionSpecialCharacters: PasswordOption = {
        let view = PasswordOption(title: "Special Characters?")
        return view
    }()
    
    let btnGenerate: UIButton = {
        let view = UIButton(frame: .zero)
        view.setTitle("Generate", for: .normal)
        view.setTitleColor(UIColor.blue, for: .normal)
        return view
    }()
    
    let indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: .zero)
        view.hidesWhenStopped = true
        view.style = .gray
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GeneratePasswordView : ViewConfigurator {
    func setupConstraints() {
        lblTitle.snp.makeConstraints { make in
            make.top.equalTo(self).offset(50)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
        }
        
        lblOptions.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.top.equalTo(lblTitle.snp.bottom).offset(16)
        }
        
        lblLength.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.top.equalTo(lblOptions.snp.bottom).offset(16)
            make.height.greaterThanOrEqualTo(22)
        }
        
        sliderLength.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.top.equalTo(lblLength.snp.bottom).offset(8)
        }
        
        optionUpperCase.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.top.equalTo(sliderLength.snp.bottom).offset(16)
        }
        
        optionDigits.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.top.equalTo(optionUpperCase.snp.bottom).offset(16)
        }
        
        optionSpecialCharacters.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.top.equalTo(optionDigits.snp.bottom).offset(16)
        }
        
        btnGenerate.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.bottom.equalTo(self).inset(50)
            make.height.equalTo(48)
        }
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(35)
        }
    }
    
    func buildViewHierarchy() {
        addSubview(lblTitle)
        addSubview(lblOptions)
        addSubview(lblLength)
        addSubview(sliderLength)
        addSubview(optionUpperCase)
        addSubview(optionDigits)
        addSubview(optionSpecialCharacters)
        addSubview(btnGenerate)
        addSubview(indicator)
    }
}

extension GeneratePasswordView {
    fileprivate func startLoading() {
        self.indicator.startAnimating()
        self.indicator.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.lblTitle.alpha = 0
            self.lblOptions.alpha = 0
            self.lblLength.alpha = 0
            self.sliderLength.alpha = 0
            self.optionUpperCase.alpha = 0
            self.optionDigits.alpha = 0
            self.optionSpecialCharacters.alpha = 0
            self.btnGenerate.alpha = 0
            self.indicator.alpha = 1
        })
    }
    
    fileprivate func reset() {
        UIView.animate(withDuration: 0.2, animations: {
            self.lblTitle.alpha = 1
            self.lblOptions.alpha = 1
            self.lblLength.alpha = 1
            self.sliderLength.alpha = 1
            self.optionUpperCase.alpha = 1
            self.optionDigits.alpha = 1
            self.optionSpecialCharacters.alpha = 1
            self.btnGenerate.alpha = 1
            self.indicator.alpha = 0
        }, completion: { _ in
            self.indicator.isHidden = true
        })
    }
}

extension Reactive where Base: GeneratePasswordView {
    var sliderValue: Binder<Int> {
        return Binder(self.base) { view, value in
            view.lblLength.text = "\(value)"
        }
    }
    
    var state: Binder<GeneratePasswordState> {
        return Binder(self.base) { view, value in
            switch value {
            case .loading:
                view.startLoading()
            case .error(let e):
                view.reset()
            case .generated(let password):
                view.reset()
            default:
                view.reset()
            }
        }
    }
}
