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
    
    private var createMemoText: String
    
    init() {
        self.createMemoText = ""
    }
    
    struct Input {
        let createButtonDidTapEvent: Observable<Void>
        let memoText: Observable<String?>
    }
    
    struct Output {
        let isSuccessCreateMemo: Observable<Bool>
    }
    
    func transform(input: Input, memo: Memo) -> Output {
        input.memoText.subscribe { [weak self] in
            guard let text = $0 else { return }
            self?.createMemoText = text
        }.disposed(by: disposeBag)
        
        let isSuccess = input.createButtonDidTapEvent.flatMapLatest { [unowned self] _ -> Observable<Bool> in
            self.createMemo(memo: memo)
        }

        return Output(isSuccessCreateMemo: isSuccess)
    }
    
    private func createMemo(memo: Memo) -> Observable<Bool> {
        let createdAt = dataFormatManager.dateToString(memo.createdAt)
        let updatedAt = dataFormatManager.dateToString(memo.updatedAt)
        
        let createMemo = MemoDB(user: memo.user, memoText: self.createMemoText, createdAt: createdAt, updatedAt: updatedAt, book: memo.book)
        
        return memoService.createMemo(memo: createMemo)
    }
}
