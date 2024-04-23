//
//  UserNickNameGetViewModel.swift
//  Boopee
//
//  Created by yunjikim on 4/5/24.
//

import UIKit
import RxSwift

final class UserNickNameGetViewModel {
    private let userInfoService = UserInfoService()
    private let dataFormatManager = DateFormatManager.dataFormatManager
    
    struct Input {
        let getUserNickNameTrigger: Observable<Void>
    }
    
    struct Output {
        let userNickName: Observable<String>
    }
    
    func transform(input: Input, userUid: String) async -> Output {
        return Output(userNickName: await userInfoService.getUserNickName(userUid: userUid))
    }
}
