//
//  UserMemoListViewModel.swift
//  Boopee
//
//  Created by yunjikim on 3/27/24.
//

import UIKit
import RxSwift

final class UserMemoListViewModel {
    private let memoService = MemoService()
    private let dataFormatManager = DateFormatManager.dataFormatManager
    
    struct Input {
        let userMemoTrigger: Observable<Void>
    }
    
    struct Output {
        let userMemoList: Observable<[Memo]>
    }
    
    func transform(input: Input, user: String) async -> Output {
        return Output(userMemoList: await self.getUserMemo(user: user))
    }
    
    private func getUserMemo(user: String) async -> Observable<[Memo]> {
        return await memoService.getUserMemo(user: user).map { memoDB in
            memoDB.map { entity in
                let createdAt = self.dataFormatManager.stringToDate(entity.createdAt)
                let updatedAt = self.dataFormatManager.stringToDate(entity.updatedAt)
                
                return Memo(id: entity.id, user: entity.user, memoText: entity.memoText, createdAt: createdAt, updatedAt: updatedAt, book: entity.book)
            }
        }
    }
}
