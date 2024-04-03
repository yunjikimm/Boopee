//
//  MemoService.swift
//  Boopee
//
//  Created by yunjikim on 3/23/24.
//

import UIKit
import RxSwift
import FirebaseCore
import FirebaseFirestore

final class MemoService {
    private let memoCollectionRef = Firestore.firestore().collection("Memos")
    
    private var memoList: [MemoDB] = []
    
    func getAllMemo() async -> Observable<[MemoDB]> {
        do {
            memoList = try await memoCollectionRef
                .order(by: "updatedAt", descending: true)
                .getDocuments().documents.map { document -> MemoDB in
                try document.data(as: MemoDB.self)
            }
            
            return Observable.create { observer in
                observer.onNext(self.memoList)
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
    
    func getUserMemo(user: String) async -> Observable<[MemoDB]> {
        do {
            memoList = try await memoCollectionRef
                .whereField("user", isEqualTo: user)
                .order(by: "updatedAt", descending: true)
                .getDocuments().documents.map { document -> MemoDB in
                try document.data(as: MemoDB.self)
            }
            
            return Observable.create { observer in
                observer.onNext(self.memoList)
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
    
    func createMemo(memo: MemoDB) -> Observable<Bool> {
        do {
            let ref = memoCollectionRef.addDocument(data: [
                "user": memo.user,
                "memoText": memo.memoText,
                "createdAt": memo.createdAt,
                "updatedAt": memo.updatedAt,
                "book": [
                    "title": memo.book.title,
                    "url": memo.book.url,
                    "isbn": memo.book.isbn,
                    "authors": memo.book.authors,
                    "publisher": memo.book.publisher,
                    "thumbnail": memo.book.thumbnail
                ]
            ])
            
            return Observable.create { observer in
                if ref.documentID.isEmpty {
                    observer.onNext(false)
                }
                observer.onNext(true)
                
                observer.onCompleted()
                
                return Disposables.create()
            }
        }
    }
    
    func updateMemo(memo: MemoDB, uid: String) async -> Observable<Bool> {
        do {
            try await self.memoCollectionRef.document(uid).updateData([
                "memoText": memo.memoText,
                "updatedAt": memo.updatedAt,
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
    
    func deleteMemo(uid: String) async -> Observable<Bool> {
        do {
            try await memoCollectionRef.document(uid).delete()
            
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
