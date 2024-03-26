//
//  BookApi.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import Foundation

struct BookApi: Decodable {
    let meta: Meta
    let documents: [BookList]
}

struct Meta: Decodable {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalCount = try container.decode(Int.self, forKey: .totalCount)
        self.pageableCount = try container.decode(Int.self, forKey: .pageableCount)
        self.isEnd = try container.decode(Bool.self, forKey: .isEnd)
    }
}

struct BookList: Decodable, Hashable {
    let title: String
    let url: String
    let isbn: String
    let authors: String
    let publisher: String
    let thumbnail: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case url
        case isbn
        case authors
        case publisher
        case thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decode(String.self, forKey: .url)
        self.isbn = try container.decode(String.self, forKey: .isbn)
        
        let authorList = try container.decode([String].self, forKey: .authors)
        let reducedAuthors = authorList.reduce("") { result, element in
            if result.count < 1 {
                return result + element
            } else {
                return result + ", " + element
            }
        }
        self.authors = reducedAuthors
        
        self.publisher = try container.decode(String.self, forKey: .publisher)
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
    }
}
