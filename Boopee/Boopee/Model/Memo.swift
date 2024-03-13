//
//  Memo.swift
//  Boopee
//
//  Created by yunjikim on 3/13/24.
//

import Foundation

struct Memo {
    let id: String = UUID().uuidString
    let memoText: String
    let createdAt: String
    let updatedAt: String
    let bookList: BookList
}
