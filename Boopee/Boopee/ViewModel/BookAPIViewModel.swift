//
//  BookAPIViewModel.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit
import RxSwift

final class BookAPIViewModel {
    private let disposeBag = DisposeBag()
    private let bookNetwork: BookNetwork
    
    init() {
        let provider = NetworkProvider()
        self.bookNetwork = provider.makeBookNetwork()
    }
    
    struct Input {
        let bookTrigger: Observable<Void>
    }
    
    struct Output {
        let bookList: Observable<[Book]>
    }
    
    func transform(input: Input, path: String) -> Output {
        let bookList = input.bookTrigger.flatMapLatest { [unowned self] _ -> Observable<[Book]> in
            self.bookNetwork.getSearchedBookList(path: path).map { book in
                book.documents.map {
                    Book(title: $0.title, url: $0.url, isbn: $0.isbn, authors: $0.authors, publisher: $0.publisher, thumbnail: $0.thumbnail)
                }
            }
        }
        
        return Output(bookList: bookList)
    }
}
