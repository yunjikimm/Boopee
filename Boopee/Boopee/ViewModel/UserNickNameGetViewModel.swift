//
//  UserNickNameGetViewModel.swift
//  Boopee
//
//  Created by yunjikim on 4/5/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import RxSwift

final class UserNickNameGetViewModel {
    private let firebaseAuth = Auth.auth()
    private let userCollectionRef = Firestore.firestore().collection("UserInfo")
    private let dataFormatManager = DateFormatManager.dataFormatManager
    
    struct Input {
        let getUserNickNameTrigger: Observable<Void>
    }
    
    struct Output {
        let userNickName: Observable<String>
    }
    
    func transform(input: Input, userUid: String) async -> Output {
        return await Output(userNickName: getUserNickName(userUid: userUid))
    }
    
    private func getUserNickName(userUid: String) async -> Observable<String> {
        do {
            let userDocumentRef = userCollectionRef.document(userUid)
            let userInfo = try await userDocumentRef.getDocument(as: UserInfo.self)
            
            return Observable.create { observer in
                observer.onNext(userInfo.nikName)
                observer.onCompleted()
                
                return Disposables.create()
            }
        } catch {
            print(error.localizedDescription)
            
            return Observable.create { observer in
                observer.onError(error)
                return Disposables.create()
            }
        }
    }
}
