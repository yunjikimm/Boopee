//
//  MemoDB.swift
//  Boopee
//
//  Created by yunjikim on 3/26/24.
//

import Foundation
import FirebaseFirestoreSwift

struct MemoDB: Decodable {
    @DocumentID var id: String?
    let user: String
    let memoText: String
    let createdAt: String
    let updatedAt: String
    let book: Book
    
    enum CodingKeys: CodingKey {
        case id
        case user
        case memoText
        case createdAt
        case updatedAt
        case book
    }
}
