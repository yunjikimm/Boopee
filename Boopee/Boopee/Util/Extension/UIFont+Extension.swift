//
//  UIFont+Extension.swift
//  Boopee
//
//  Created by yunjikim on 3/31/24.
//

import UIKit

extension UIFont {
    // font size, weight
    static let bookTitleFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
    static let bookAuthorsFont: UIFont = .systemFont(ofSize: 12, weight: .light)
    static let bookPublisherFont: UIFont = .systemFont(ofSize: 12, weight: .light)
    
    static let memoTextFont: UIFont = .systemFont(ofSize: 16, weight: .regular)
    static let memoTextPreviewFont: UIFont = .systemFont(ofSize: 14, weight: .regular)
    
    static let memoDateFont: UIFont = .systemFont(ofSize: 12, weight: .regular)
    
    static let memoLimitFont: UIFont = .systemFont(ofSize: 14, weight: .regular)
    
    static let memoCountFont: UIFont = .systemFont(ofSize: 14, weight: .regular)
    
    static let emptyItemMessageFont: UIFont = .systemFont(ofSize: 16, weight: .regular)
    
    // custom font size, weigth
    static let largeBold: UIFont = .systemFont(ofSize: 16, weight: .bold)
    static let largeRegular: UIFont = .systemFont(ofSize: 16, weight: .regular)
    static let mediumRegular: UIFont = .systemFont(ofSize: 14, weight: .regular)
    static let smallRegular: UIFont = .systemFont(ofSize: 12, weight: .regular)
    static let smallLight: UIFont = .systemFont(ofSize: 12, weight: .light)
}
