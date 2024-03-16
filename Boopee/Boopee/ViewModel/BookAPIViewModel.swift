//
//  BookAPIViewModel.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit
import RxSwift

class BookAPIViewModel {
    let disposeBag = DisposeBag()
    
    private let bookNetwork: BookNetwork
    
    init() {
        let provider = NetworkProvider()
        self.bookNetwork = provider.makeBookNetwork()
    }
    
    struct Input {
        let bookTrigger: Observable<Void>
    }
    
    struct Output {
        let bookList: Observable<[BookList]>
    }
    
    func transform(input: Input, path: String) -> Output {
        let bookList = input.bookTrigger.flatMapLatest { [unowned self] _ -> Observable<[BookList]> in
            self.bookNetwork.getSearchedBookList(path: path).map { $0.documents }
        }
        
        return Output(bookList: bookList)
    }
}