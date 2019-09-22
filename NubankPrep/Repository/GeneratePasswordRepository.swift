//
//  GeneratePasswordRepository.swift
//  NubankPrep
//
//  Created by Gabriel Araujo on 21/09/19.
//  Copyright © 2019 Gabriel Araujo. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol GeneratePasswordRepository {
    func generate(options: PasswordOptions) -> Observable<Result<GeneratedPassword>>
}

class GeneratePasswordAPIRepository : GeneratePasswordRepository {
    
    let provider: MoyaProvider<APIConfig>
    
    init(provider: MoyaProvider<APIConfig> = MoyaProvider<APIConfig>(stubClosure: MoyaProvider.delayedStub(2.0))) {
        self.provider = provider
    }
    
    func generate(options: PasswordOptions) -> Observable<Result<GeneratedPassword>> {
        return provider.rx.request(APIConfig.generatePassword)
            .filterSuccessfulStatusCodes()
            .map(GeneratedPassword.self)
            .asObservable()
            .materialize()
            .flatMap { resp -> Observable<Result<GeneratedPassword>> in
                if let e = resp.error {
                    return Observable.just(Result.Failure(e))
                }
                if let object = resp.element {
                    return Observable.just(Result.Success(object))
                }
                
                return Observable.empty()
            }
    }
}
