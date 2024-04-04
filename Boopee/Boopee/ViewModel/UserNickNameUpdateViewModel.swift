//
//  UserNickNameUpdateViewModel.swift
//  Boopee
//
//  Created by yunjikim on 4/4/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import RxSwift

final class UserNickNameUpdateViewModel {
    private let firebaseAuth = Auth.auth()
    private let userCollectionRef = Firestore.firestore().collection("UserInfo")
    
    struct Input {
        let updateButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        let isSuccessUpdateMemo: Observable<Bool>
    }
    
    func transform(input: Input, nickName: String) async -> Output {
        return Output(isSuccessUpdateMemo: await updateNickName(nickName: nickName))
    }
    
    private func updateNickName(nickName: String) async -> Observable<Bool> {
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
}
