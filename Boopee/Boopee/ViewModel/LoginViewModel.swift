//
//  SignInViewModel.swift
//  Boopee
//
//  Created by yunjikim on 3/14/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleSignIn

@MainActor
final class LoginViewModel {
    let firebaseAuth = Auth.auth()
    private let userCollectionRef = Firestore.firestore().collection("UserInfo")
    
    private let dataFormatManager = DateFormatManager.dataFormatManager
    
    var loginUser: User?
    var userInfo: UserInfo?
    
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
            
            try await userCollectionRef.document(signIn.user.uid).setData([
                "displayName": signIn.user.displayName ?? "",
                "nikName": signIn.user.displayName ?? "",
                "email": signIn.user.email ?? "",
                "creationDate": dataFormatManager.dateToString(signIn.user.metadata.creationDate ?? Date())
            ])
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
