//
//  BookNetwork.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit
import RxSwift

final class BookNetwork {
    private let network: Netwrok<BookApi>
    
    init(network: Netwrok<BookApi>) {
        self.network = network
    }
    
    func getSearchedBookList(path: String) -> Observable<BookApi> {
        return network.getSearchedBookList(path: path)
    }
}
