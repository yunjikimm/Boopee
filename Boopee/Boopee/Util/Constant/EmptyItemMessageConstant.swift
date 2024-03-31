//
//  EmptyItemMessageConstant.swift
//  Boopee
//
//  Created by yunjikim on 3/31/24.
//

import Foundation

enum EmptyItemMessageConstant: String {
    case home = "메모가 없습니다.\n책을 검색하고 메모를 작성해보세요!"
    case search = "책을 검색하고 메모를 작성해보세요!"
    case mypage = "작성한 메모가 없습니다.\n책을 검색하고 메모를 작성해보세요!"
    
    var buttonText: String {
        switch self {
        case .home, .search, .mypage:
            return "메모 작성하러 가기"
        }
    }
}
