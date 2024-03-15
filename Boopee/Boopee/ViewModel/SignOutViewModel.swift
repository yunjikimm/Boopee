//
//  SignOutViewModel.swift
//  Boopee
//
//  Created by yunjikim on 3/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import GoogleSignIn

final class SignOutViewModel {
    static let signOutViewModel = SignOutViewModel()
    let disposeBag = DisposeBag()
    let firebaseAuth = Auth.auth()
    
    struct Input {
        let signOutButtonTapped: Driver<Void>
    }
    struct Output {
        let isSignOutSuccessSignal: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        input.signOutButtonTapped.drive { [weak self] _ in
            self?.signOut()
        }.disposed(by: disposeBag)
        
        return Output(isSignOutSuccessSignal: input.signOutButtonTapped.asDriver())
    }
    
    private func signOut() {
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
