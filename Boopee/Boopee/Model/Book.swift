//
//  Book.swift
//  Boopee
//
//  Created by yunjikim on 3/25/24.
//

import Foundation

struct Book: Decodable, Hashable {
    let title: String
    let url: String
    let isbn: String
    let authors: String
    let publisher: String
    let thumbnail: String
}
