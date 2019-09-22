//
//  PasswordOptions.swift
//  NubankPrep
//
//  Created by Gabriel Araujo on 21/09/19.
//  Copyright © 2019 Gabriel Araujo. All rights reserved.
//

import Foundation

struct PasswordOptions : Codable {
    let length: Int
    let uppercase: Bool
    let containDigits: Bool
    let specialCharacters: Bool
    
    init(length: Int, uppercase: Bool, containDigits: Bool, specialCharacters: Bool) {
        self.length = length
        self.uppercase = uppercase
        self.containDigits = containDigits
        self.specialCharacters = specialCharacters
    }
}
