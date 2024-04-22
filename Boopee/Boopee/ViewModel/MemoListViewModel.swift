//
//  MemoListViewModel.swift
//  Boopee
//
//  Created by yunjikim on 3/26/24.
//

import UIKit
import RxSwift
import FirebaseFirestore

final class MemoListViewModel {
    private let memoService = MemoService()
    private var lastDocument: DocumentSnapshot? = nil
    private let dataFormatManager = DateFormatManager.dataFormatManager
    
    struct Input {
        let memoTrigger: Observable<Void>
    }
    
    struct Output {
        let memoList: Observable<[Memo]>
    }
    
    func transform(input: Input) async -> Output {
        return Output(memoList: await self.getAllMemo())
    }
    
    private func getAllMemo() async -> Observable<[Memo]> {
        return await memoService.getAllMemo(lastDocument: lastDocument).map { memoList, lastDocument in
            guard let lastDocument = lastDocument else { return [] }
            
            if lastDocument.exists {
                self.lastDocument = lastDocument
                
                return memoList.map { entity in
                    let createdAt = self.dataFormatManager.stringToDate(entity.createdAt)
                    let updatedAt = self.dataFormatManager.stringToDate(entity.updatedAt)
                    return Memo(id: entity.id, user: entity.user, memoText: entity.memoText, createdAt: createdAt, updatedAt: updatedAt, book: entity.book)
                }
            } else {
                return []
            }
        }
    }
}
