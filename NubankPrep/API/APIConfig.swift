//
//  APIConfig.swift
//  NubankPrep
//
//  Created by Gabriel Araujo on 21/09/19.
//  Copyright © 2019 Gabriel Araujo. All rights reserved.
//

import Foundation
import Moya

let apiProvider = MoyaProvider<APIConfig>()

enum APIConfig {
    case generatePassword
}

extension APIConfig : TargetType {
    var baseURL: URL {
        let base = "http://passwordutility.net:80/api"
        return URL(string: base)!
    }
    
    var path: String {
        switch self {
        case .generatePassword:
            return "/password/generate"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .generatePassword:
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "{\"password\": \"123456Aa\"}".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .generatePassword:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
