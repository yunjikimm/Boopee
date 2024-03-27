//
//  MemoUpdateViewModel.swift
//  Boopee
//
//  Created by yunjikim on 3/28/24.
//

import UIKit
import RxSwift

final class MemoUpdateViewModel {
    private let memoService = MemoService()
    private let dataFormatManager = DateFormatManager.dataFormatManager
    private let disposeBag = DisposeBag()
    
    struct Input {
        let updateButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        let isSuccessUpdateMemo: Observable<Bool>
    }
    
    func transform(input: Input, memo: Memo, uid: String, text: String) async -> Output {
        return await Output(isSuccessUpdateMemo: updateMemo(memo: memo, uid: uid, text: text))
    }
    
    private func updateMemo(memo: Memo, uid: String, text: String) async -> Observable<Bool> {
        let createdAt = dataFormatManager.dateToString(memo.createdAt)
        let updatedAt = dataFormatManager.dateToString(Date())
        
        let updateMemo = MemoDB(user: memo.user, memoText: text, createdAt: createdAt, updatedAt: updatedAt, book: memo.book)
        
        return await memoService.updateMemo(memo: updateMemo, uid: uid)
    }
}
