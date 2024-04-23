//
//  UserInfoViewModel.swift
//  Boopee
//
//  Created by yunjikim on 4/3/24.
//

import UIKit
import RxSwift

final class UserInfoViewModel {
    private let userInfoService = UserInfoService()
    private let dataFormatManager = DateFormatManager.dataFormatManager
    
    struct Input {
        let userInfoTrigger: Observable<Void>
    }
    
    struct Output {
        let userInfo: Observable<UserInfo>
    }
    
    func transform(input: Input) async -> Output {
        return Output(userInfo: await getUserInfo())
    }
    
    private func getUserInfo() async -> Observable<UserInfo> {
        return await userInfoService.getUserInfo().map { entity in
            let creationDate = self.dataFormatManager.stringToDate(entity.creationDate)
            
            return UserInfo(id: entity.id, displayName: entity.displayName, nikName: entity.nikName, email: entity.email, creationDate: creationDate)
        }
    }
}
