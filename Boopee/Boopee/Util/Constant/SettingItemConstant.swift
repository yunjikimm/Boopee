//
//  SettingItemConstant.swift
//  Boopee
//
//  Created by yunjikim on 3/28/24.
//

import Foundation

enum SettingItemConstant: String {
    case serviceUsageGuide = "서비스이용약관"
    case privacyPolicy = "개인정보처리방침"
    
    var url: String {
        switch self {
        case .serviceUsageGuide:
            return "https://yunji-kim.notion.site/d5ca0bd190b84cd28a16a34b944f767f?pvs=4"
        case .privacyPolicy:
            return "https://yunji-kim.notion.site/a10d1007c60d479b8c6910d4cbdaa242?pvs=4"
        }
    }
}
