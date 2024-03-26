//
//  BookNetwork.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit
import RxSwift
import RxAlamofire

final class BookNetwork {
    private let endpoint: String
    private let queue: ConcurrentDispatchQueueScheduler
    
    private var apikey: String {
        guard let apikey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_API_KEY") as? String else { return "" }
        return apikey
    }
    
    init(endpoint: String) {
        self.endpoint = endpoint
        self.queue = ConcurrentDispatchQueueScheduler(qos: .background)
    }
    
    func getSearchedBookList(path: String) -> Observable<BookApi> {
        let fullPath = "\(endpoint)?query=\(path)"
        
        return RxAlamofire
            .data(.get, fullPath, headers: ["Authorization": "KakaoAK \(apikey)"])
            .observe(on: queue)
            .debug()
            .map { data -> BookApi in
                return try JSONDecoder().decode(BookApi.self, from: data)
            }
    }
}
