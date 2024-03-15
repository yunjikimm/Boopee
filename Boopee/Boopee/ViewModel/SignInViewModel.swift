//
//  SignInViewModel.swift
//  Boopee
//
//  Created by yunjikim on 3/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import GoogleSignIn

final class SignInViewModel {
    static let signInViewModel = SignInViewModel()
    let disposeBag = DisposeBag()
    let firebaseAuth = Auth.auth()
    
    struct Input {
        let googleLoginButtonTapped: Signal<Void>
    }
    struct Output {
        let isLoginSuccessSignal: Signal<Void>
    }
    
    func transform(input: Input, viewController: UIViewController) -> Output {
        input.googleLoginButtonTapped.emit { [weak self] _ in
            self?.googleSignIn(viewController: viewController)
        }.disposed(by: disposeBag)
        
        return Output(isLoginSuccessSignal: input.googleLoginButtonTapped.asSignal())
    }
    
    private func googleSignIn(viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController.self) { [unowned self] result, error in
            guard error == nil else { return }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            googleSignInWithFirebaseAuth(credential: credential)
        }
    }
    
    private func googleSignInWithFirebaseAuth(credential: AuthCredential) {
        firebaseAuth.signIn(with: credential) { result, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("login successful")
            }
        }
    }
}
