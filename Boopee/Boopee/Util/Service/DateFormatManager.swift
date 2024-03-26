//
//  DateFormatManager.swift
//  Boopee
//
//  Created by yunjikim on 3/24/24.
//

import Foundation

final class DateFormatManager {
    static let dataFormatManager = DateFormatManager()
    let dateFormatter = DateFormatter()
    
    func stringToDate(_ dateString: String) -> Date {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
        
        guard let date = dateFormatter.date(from: dateString) else { return Date() }
        
        return date
    }
    
    func dateToString(_ date: Date) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        return dateFormatter.string(from: date)
    }
    
    func MemoDateToString(_ date: Date) -> String {
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        return dateFormatter.string(from: date)
    }
}
