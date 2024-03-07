//
//  NetworkProvider.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit

final class NetworkProvider {
    private let endpoint: String
    
    init() {
        self.endpoint = "https://dapi.kakao.com/v3/search/book"
    }
    
    func makeBookNetwork() -> BookNetwork {
        let network = Netwrok<BookListModel>(endpoint: endpoint)
        return BookNetwork(network: network)
    }
}
