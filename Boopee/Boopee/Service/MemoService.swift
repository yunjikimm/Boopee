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
    
    func getAllMemo(lastDocument: DocumentSnapshot?) async -> Observable<([MemoDB], DocumentSnapshot?)> {
        do {
            let pageSize: Int = 2
            var query: ([MemoDB], DocumentSnapshot?)? = nil
            
            if let lastDocument {
                query = try await memoCollectionRef
                    .order(by: "updatedAt", descending: true)
                    .limit(to: 1)
                    .start(afterDocument: lastDocument)
                    .getDocumentsWithSnapshot(as: MemoDB.self)
            } else {
                query = try await memoCollectionRef
                    .order(by: "updatedAt", descending: true)
                    .limit(to: pageSize)
                    .getDocumentsWithSnapshot(as: MemoDB.self)
            }
            
            return Observable.create { observer in
                observer.onNext(query ?? ([], lastDocument))
                observer.onCompleted()
                
                return Disposables.create()
            }
        } 
        catch {
            print(error.localizedDescription)
            
            return Observable.create { observer in
                observer.onError(error)
                return Disposables.create()
            }
        }
    }
    
    func getUserMemo(user: String, lastDocument: DocumentSnapshot?, isFirst: Bool) async -> Observable<([MemoDB], DocumentSnapshot?)> {
        do {
            let pageSize: Int = 5
            var query: ([MemoDB], DocumentSnapshot?)? = nil
            var lastDocumentSnapshot = lastDocument
            
            if isFirst {
                lastDocumentSnapshot = nil
            }
            
            if let lastDocumentSnapshot {
                query = try await memoCollectionRef
                    .whereField("user", isEqualTo: user)
                    .order(by: "updatedAt", descending: true)
                    .limit(to: pageSize)
                    .start(afterDocument: lastDocumentSnapshot)
                    .getDocumentsWithSnapshot(as: MemoDB.self)
            } else {
                query = try await memoCollectionRef
                    .whereField("user", isEqualTo: user)
                    .order(by: "updatedAt", descending: true)
                    .limit(to: pageSize)
                    .getDocumentsWithSnapshot(as: MemoDB.self)
            }
            
            return Observable.create { observer in
                observer.onNext(query ?? ([], lastDocumentSnapshot))
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

extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        let (results, _) = try await getDocumentsWithSnapshot(as: type)
        return results
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> ([T], DocumentSnapshot?) where T: Decodable {
        let snapshot = try await self.getDocuments()
        
        let results = try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
        
        return (results, snapshot.documents.last)
    }
}
