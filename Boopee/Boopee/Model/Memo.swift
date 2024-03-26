//
//  Memo.swift
//  Boopee
//
//  Created by yunjikim on 3/13/24.
//

import Foundation
import FirebaseFirestoreSwift

struct Memo: Hashable {
    @DocumentID var id: String?
    let user: String
    let memoText: String
    let createdAt: Date
    let updatedAt: Date
    let book: Book
}
