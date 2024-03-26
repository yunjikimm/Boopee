//
//  SectionItemConstant.swift
//  Boopee
//
//  Created by yunjikim on 3/26/24.
//

import Foundation

enum Section: Hashable {
    case home
    case searchResult
}

enum Item: Hashable {
    case memoList(Memo)
    case bookList(Book)
}
