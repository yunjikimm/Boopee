//
//  MemoDeleteViewModel.swift
//  Boopee
//
//  Created by yunjikim on 3/27/24.
//

import UIKit
import RxSwift

final class MemoDeleteViewModel {
    private let memoService = MemoService()
    private let dataFormatManager = DateFormatManager.dataFormatManager
    
    struct Input {
        let deleteMemoTrigger: Observable<Void>
    }
    
    struct Output {
        let deleteButtonDidTapEvent: Observable<Bool>
    }
    
    func transform(input: Input, uid: String) async -> Output {
        return await Output(deleteButtonDidTapEvent: deleteMemo(uid: uid))
    }
    
    private func deleteMemo(uid: String) async -> Observable<Bool> {
        return await memoService.deleteMemo(uid: uid)
    }
}
