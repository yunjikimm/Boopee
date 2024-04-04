//
//  UserInfo.swift
//  Boopee
//
//  Created by yunjikim on 4/3/24.
//

import Foundation

struct UserInfo: Decodable, Hashable {
    let id: String?
    let displayName: String
    let nikName: String
    let email: String
    let creationDate: String
}
