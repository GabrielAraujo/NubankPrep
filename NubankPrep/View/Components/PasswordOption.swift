//
//  PasswordOption.swift
//  NubankPrep
//
//  Created by Gabriel Araujo on 21/09/19.
//  Copyright © 2019 Gabriel Araujo. All rights reserved.
//

import UIKit
import SnapKit

class PasswordOption: UIView {
    
    let title: String
    
    let switchControl: UISwitch = {
       let view = UISwitch(frame: .zero)
        return view
    }()
    
    lazy var lblTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = view.font.withSize(18.0)
        view.text = self.title
        return view
    }()
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PasswordOption : ViewConfigurator {
    func setupConstraints() {
        switchControl.snp.makeConstraints { make in
            make.top.equalTo(self).offset(16)
            make.left.equalTo(self).offset(16)
            make.bottom.equalTo(self).inset(16)
        }
        
        lblTitle.snp.makeConstraints { make in
            make.left.equalTo(switchControl.snp.right).offset(16)
            make.top.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.bottom.equalTo(self).inset(16)
        }
    }
    
    func buildViewHierarchy() {
        addSubview(switchControl)
        addSubview(lblTitle)
    }
}
