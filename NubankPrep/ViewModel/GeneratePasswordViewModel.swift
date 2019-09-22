//
//  GeneratePasswordViewModel.swift
//  NubankPrep
//
//  Created by Gabriel Araujo on 21/09/19.
//  Copyright © 2019 Gabriel Araujo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

enum GeneratePasswordState {
    case initial
    case loading
    case generated(password: String)
    case error(error: Error)
}

extension GeneratePasswordState: Equatable {
    static func ==(lhs: GeneratePasswordState, rhs: GeneratePasswordState)
        -> Bool {
            switch (lhs, rhs) {
            case (.initial, .initial): return true
            case (.loading, .loading): return true
            case let (.generated(l), .generated(r)): return l == r
            case let (.error(l), .error(r)): return String(describing: l) == String(describing: r)
            default: return false
            }
    }
}

class GeneratePasswordViewModel {
    
    // Output
    let selectedLength: Driver<Int>
    let state: Driver<GeneratePasswordState>
    
    init(passwordLength: Observable<Float>,
         selectedUppercase: Observable<Bool>,
         selectedContainsDigits: Observable<Bool>,
         selectedSpecialCharacters: Observable<Bool>,
         tappedGenerate: Observable<Void>,
         repository: GeneratePasswordRepository = GeneratePasswordAPIRepository()) {
        
        let activityIndicator = ActivityIndicator()
        
        let passwordSize = passwordLength
            .map { $0.roundedInt() }
        
        let initialState: Observable<GeneratePasswordState> = Observable.just(.initial)
        
        let requestPassword = tappedGenerate
            .flatMap { _ -> Observable<PasswordOptions> in
                return Observable.combineLatest(passwordSize, selectedUppercase, selectedContainsDigits, selectedSpecialCharacters)
                    .map {
                        PasswordOptions(length: $0.0, uppercase: $0.1, containDigits: $0.2, specialCharacters: $0.3)
                    }
            }
            .flatMap { repository.generate(options: $0).trackActivity(activityIndicator) }
            .map { result -> GeneratePasswordState in
                switch result {
                    case .Success(let obj):
                        return GeneratePasswordState.generated(password: obj.password)
                    case .Failure(let err):
                        return GeneratePasswordState.error(error: err)
                }
            }
        
        let isLoading = activityIndicator
            .asObservable()
            .filter { $0 }
            .map { _ in GeneratePasswordState.loading }
        
        let lastState = Observable.merge(initialState, requestPassword, isLoading)
        
        selectedLength = passwordSize
            .asDriver(onErrorDriveWith: Driver.empty())
        
        state = lastState
            .asDriver(onErrorDriveWith: Driver.empty())
        
    }
    
}
