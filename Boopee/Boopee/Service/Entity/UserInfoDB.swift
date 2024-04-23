//
//  UserInfoDB.swift
//  Boopee
//
//  Created by yunjikim on 4/23/24.
//

import Foundation
import FirebaseFirestoreSwift

struct UserInfoDB: Decodable {
    @DocumentID var id: String?
    let displayName: String
    let nikName: String
    let email: String
    let creationDate: String
    
    enum CodingKeys: CodingKey {
        case id
        case displayName
        case nikName
        case email
        case creationDate
    }
}
