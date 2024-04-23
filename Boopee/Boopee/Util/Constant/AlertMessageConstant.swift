//
//  AlertMessageConstant.swift
//  Boopee
//
//  Created by yunjikim on 4/23/24.
//

import Foundation

enum AlertMessageConstant: String {
    case deleteMemo = "메모 삭제"
    case logout = "로그아웃"
    
    var alertText: String {
        switch self {
        case .deleteMemo:
            return "메모를 삭제하시겠습니까?"
        case .logout:
            return "로그아웃하시겠습니까?"
        }
    }
}
