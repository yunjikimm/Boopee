//
//  UserNickNameUpdateViewModel.swift
//  Boopee
//
//  Created by yunjikim on 4/4/24.
//

import UIKit
import RxSwift

final class UserNickNameUpdateViewModel {
    private let userInfoService = UserInfoService()
    
    struct Input {
        let updateButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        let isSuccessUpdateMemo: Observable<Bool>
    }
    
    func transform(input: Input, nickName: String) async -> Output {
        return Output(isSuccessUpdateMemo: await userInfoService.updateNickName(nickName: nickName))
    }
}
