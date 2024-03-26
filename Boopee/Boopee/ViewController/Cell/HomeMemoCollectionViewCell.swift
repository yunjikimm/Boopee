//
//  HomeMemoCollectionViewCell.swift
//  Boopee
//
//  Created by yunjikim on 3/26/24.
//

import UIKit
import Kingfisher

final class HomeMemoCollectionViewCell: UICollectionViewCell {
    static let id = "HomeMemoCollectionViewCell"
    
    private let bookThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    private let bookAuthorsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    private let bookPublisherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        addSubview(bookThumbnailImageView)
//        addSubview(bookTitleLabel)
//        addSubview(bookAuthorsLabel)
//        addSubview(bookPublisherLabel)
        
        bookThumbnailImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    public func configure(item: Memo) {
        let thumbnailURL = URL(string: item.book.thumbnail)
        
        bookThumbnailImageView.kf.setImage(with: thumbnailURL)
        bookTitleLabel.text = item.book.title
        bookAuthorsLabel.text = item.book.authors
        bookPublisherLabel.text = item.book.publisher
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
