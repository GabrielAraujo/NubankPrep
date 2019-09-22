//
//  ViewConfigurator.swift
//  NubankPrep
//
//  Created by Gabriel Araujo on 21/09/19.
//  Copyright © 2019 Gabriel Araujo. All rights reserved.
//

import Foundation

protocol ViewConfigurator {
    func setupConstraints()
    func buildViewHierarchy()
    func setup()
}

extension ViewConfigurator {
    func setup() {
        buildViewHierarchy()
        setupConstraints()
    }
}
