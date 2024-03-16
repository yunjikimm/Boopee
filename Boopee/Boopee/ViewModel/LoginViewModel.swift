//
//  SignInViewModel.swift
//  Boopee
//
//  Created by yunjikim on 3/14/24.
//

import UIKit
import Firebase
import GoogleSignIn

final class LoginViewModel {
    static let loginViewModel = LoginViewModel()
    let firebaseAuth = Auth.auth()
    
    func googleSignIn(viewController: UIViewController) {
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
    
    func signOut() {
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
