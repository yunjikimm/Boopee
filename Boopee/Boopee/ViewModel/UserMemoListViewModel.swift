//
//  UserMemoListViewModel.swift
//  Boopee
//
//  Created by yunjikim on 3/27/24.
//

import UIKit
import RxSwift
import FirebaseFirestore

final class UserMemoListViewModel {
    private let memoService = MemoService()
    private var lastDocument: DocumentSnapshot? = nil
    private let dataFormatManager = DateFormatManager.dataFormatManager
    
    private var initPageSize: Int = 5
    private var firstFlag: Bool = true
    
    struct Input {
        let firstFetchUserMemoTrigger: Observable<Bool>
    }
    
    struct Output {
        let userMemoList: Observable<[Memo]>
    }
    
    func transform(input: Input, user: String) async -> Output {
        input.firstFetchUserMemoTrigger.subscribe { [weak self] isFirst in
            guard let isFirst = isFirst.element else { return }
            self?.firstFlag = isFirst
        }.disposed(by: DisposeBag())
        
        return Output(userMemoList: await getUserMemo(user: user, isFirst: firstFlag))
    }
    
    private func getUserMemo(user: String, isFirst: Bool) async -> Observable<[Memo]> {
        return await memoService.getUserMemo(user: user, lastDocument: lastDocument, isFirst: isFirst).map { memoList, lastDocument in
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
