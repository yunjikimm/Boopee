//
//  UserInfoService.swift
//  Boopee
//
//  Created by yunjikim on 4/23/24.
//

import UIKit
import RxSwift
import Firebase
import FirebaseFirestore

final class UserInfoService {
    private let firebaseAuth = Auth.auth()
    private let userCollectionRef = Firestore.firestore().collection("UserInfo")
    
    func getUserInfo() async -> Observable<UserInfoDB> {
        do {
            guard let userUid = firebaseAuth.currentUser?.uid else {
                return Observable.create { observer in
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
            
            let userDocumentRef = userCollectionRef.document(userUid)
            let userInfo = try await userDocumentRef.getDocument(as: UserInfoDB.self)
            
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
    
    func updateNickName(nickName: String) async -> Observable<Bool> {
        do {
            guard let uid = firebaseAuth.currentUser?.uid else {
                return Observable.create { observer in
                    observer.onNext(false)
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
            
            try await self.userCollectionRef.document(uid).updateData([
                "nikName": nickName
            ])
            
            return Observable.create { observer in
                observer.onNext(true)
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
    
    func getUserNickName(userUid: String) async -> Observable<String> {
        do {
            let userDocumentRef = userCollectionRef.document(userUid)
            let userInfo = try await userDocumentRef.getDocument(as: UserInfoDB.self)
            
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
