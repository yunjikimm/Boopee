//
//  Network.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit
import RxSwift
import RxAlamofire

class Netwrok<T:Decodable> {
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
    
    func getSearchedBookList(path: String) -> Observable<T> {
        let fullPath = "\(endpoint)?query=\(path)"
        
        return RxAlamofire
            .data(.get, fullPath, headers: ["Authorization": "KakaoAK \(apikey)"])
            .observe(on: queue)
            .debug()
            .map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
}

// endpoint: https://dapi.kakao.com/v3/search/book
// https://dapi.kakao.com/v3/search/book?query=미움받을 용기
