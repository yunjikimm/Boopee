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
    let firebaseAuth = Auth.auth()
    
    var loginUser: User?
    
    func googleSignIn(viewController: UIViewController) async throws {
        do {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            let gidSignIn = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController.self)
            guard let idToken = gidSignIn.user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: gidSignIn.user.accessToken.tokenString)
            try await googleSignInWithFirebaseAuth(credential: credential)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func googleSignInWithFirebaseAuth(credential: AuthCredential) async throws {
        do {
            let signIn = try await firebaseAuth.signIn(with: credential)
            loginUser = signIn.user
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func signOut() async throws -> Bool {
        do {
            try firebaseAuth.signOut()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
