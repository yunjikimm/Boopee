//
//  UserInfoViewModel.swift
//  Boopee
//
//  Created by yunjikim on 4/3/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import RxSwift

final class UserInfoViewModel {
    private let firebaseAuth = Auth.auth()
    private let userCollectionRef = Firestore.firestore().collection("UserInfo")
    private let dataFormatManager = DateFormatManager.dataFormatManager
    
    struct Input {
        let userInfoTrigger: Observable<Void>
    }
    
    struct Output {
        let userInfo: Observable<UserInfo>
    }
    
    func transform(input: Input) async -> Output {
        return Output(userInfo: await self.getUserInfo())
    }
    
    private func getUserInfo() async -> Observable<UserInfo> {
        do {
            guard let userUid = firebaseAuth.currentUser?.uid else {
                return Observable.create { observer in
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
            
            let userDocumentRef = userCollectionRef.document(userUid)
            let userInfo = try await userDocumentRef.getDocument(as: UserInfo.self)
            
            return Observable.create { observer in
                observer.onNext(userInfo)
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
