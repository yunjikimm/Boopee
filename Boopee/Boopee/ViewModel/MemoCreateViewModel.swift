//
//  MemoViewModel.swift
//  Boopee
//
//  Created by yunjikim on 3/23/24.
//

import UIKit
import RxSwift

// Service에서 받아온 데이터를 View에 나타낼 수 있도록 데이터 변환
final class MemoCreateViewModel {
    private let memoService = MemoService()
    private let dataFormatManager = DateFormatManager.dataFormatManager
    private let disposeBag = DisposeBag()
    
    struct Input {
        let createButtonDidTapEvent: Observable<Void>
//        let memoText: Observable<String?>
    }
    
    struct Output {
        let isSuccessCreateMemo: Observable<Bool>
    }
    
    func transform(input: Input, memo: Memo) -> Output {
        return Output(isSuccessCreateMemo: createMemo(memo: memo))
    }
    
    private func createMemo(memo: Memo) -> Observable<Bool> {
        let createdAt = dataFormatManager.dateToString(memo.createdAt)
        let updatedAt = dataFormatManager.dateToString(memo.updatedAt)
        
        let createMemo = MemoDB(user: memo.user, memoText: memo.memoText, createdAt: createdAt, updatedAt: updatedAt, book: memo.book)
        
        return memoService.createMemo(memo: createMemo)
    }
}
