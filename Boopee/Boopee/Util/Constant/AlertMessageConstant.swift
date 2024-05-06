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
    case leaveMembership = "회원탈퇴"
    
    var alertText: String {
        switch self {
        case .deleteMemo:
            return "메모를 삭제하시겠습니까?"
        case .logout:
            return "로그아웃하시겠습니까?"
        case .leaveMembership:
            return "탈퇴하시겠습니까?"
        }
    }
}
