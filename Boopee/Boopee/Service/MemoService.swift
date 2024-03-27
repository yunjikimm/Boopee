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
        } catch {
            print(error.localizedDescription)
        }
        
        return Observable.create { emitter in
            emitter.onNext(self.memoList)
            emitter.onCompleted()
            
            return Disposables.create()
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
        } catch {
            print(error.localizedDescription)
        }
        
        return Observable.create { emitter in
            emitter.onNext(self.memoList)
            emitter.onCompleted()
            
            return Disposables.create()
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
            
            return Observable.create { emitter in
                if ref.documentID.isEmpty {
                    emitter.onNext(false)
                }
                emitter.onNext(true)
                
                return Disposables.create()
            }
        }
    }
    
    func deleteMemo(uid: String) async -> Observable<Bool> {
        var isDeleted: Bool = false
        
        do {
            try await memoCollectionRef.document(uid).delete()
            isDeleted = true
        } catch {
            print(error.localizedDescription)
            isDeleted = false
        }
        
        return Observable.create { emitter in
            emitter.onNext(isDeleted)
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
}
