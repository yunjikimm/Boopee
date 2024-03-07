//
//  BookNetwork.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit
import RxSwift

final class BookNetwork {
    private let network: Netwrok<BookListModel>
    
    init(network: Netwrok<BookListModel>) {
        self.network = network
    }
    
    func getSearchedBookList(path: String) -> Observable<BookListModel> {
        return network.getSearchedBookList(path: path)
    }
}
