//
//  MemoService.swift
//  Boopee
//
//  Created by yunjikim on 3/23/24.
//

import UIKit
import RxSwift
import RxRelay
import FirebaseCore
import FirebaseFirestore

// ServiceProvider를 이용해서 Entity를 뷰 로직에서 사용하는 모델로 바꾸어주는 역할
// Entity에서 필요한 것만 정제한 후 변형할 수 있다.
// Memo 관련 동작은 실제로 Service에서 일어나며 핵심 비즈니스 로직이라고 할 수 있다.
final class MemoService {
    private let memoCollectionRef = Firestore.firestore().collection("Memos")
    
    private var memoList: [MemoDB] = []
    
    func getAllMemo() async -> Observable<[MemoDB]> {
        do {
            memoList = try await memoCollectionRef.getDocuments().documents.map { document -> MemoDB in
                try document.data(as: MemoDB.self)
            }
        } catch {
            print(error.localizedDescription)
        }
        
//        return BehaviorRelay(value: memoList)
        
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
}
