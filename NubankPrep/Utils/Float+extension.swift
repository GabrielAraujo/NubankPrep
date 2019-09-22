//
//  Float+extension.swift
//  NubankPrep
//
//  Created by Gabriel Araujo on 21/09/19.
//  Copyright © 2019 Gabriel Araujo. All rights reserved.
//

import Foundation

extension Float {
    func roundedInt() -> Int {
        return Int(roundf(self * 1.0))
    }
}
