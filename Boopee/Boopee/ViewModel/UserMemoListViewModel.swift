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
    
    private var firstFetchDataFlag: Bool = true
    
    struct Input {
        let firstFetchUserMemoTrigger: Observable<Bool>
    }
    
    struct Output {
        let userMemoList: Observable<[Memo]>
    }
    
    func transform(input: Input, user: String) async -> Output {
        input.firstFetchUserMemoTrigger.subscribe { [weak self] isFirstFetchData in
            guard let isFirstFetchData = isFirstFetchData.element else { return }
            self?.firstFetchDataFlag = isFirstFetchData
        }.disposed(by: DisposeBag())
        
        return Output(userMemoList: await getUserMemo(user: user, isFirstFetchData: firstFetchDataFlag))
    }
    
    private func getUserMemo(user: String, isFirstFetchData: Bool) async -> Observable<[Memo]> {
        return await memoService.getUserMemo(user: user, lastDocument: lastDocument, isFirstFetchData: isFirstFetchData).map { memoList, lastDocument in
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
