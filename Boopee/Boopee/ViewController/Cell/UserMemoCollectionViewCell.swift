//
//  MypageMemoCollectionViewCell.swift
//  Boopee
//
//  Created by yunjikim on 3/27/24.
//

import UIKit
import Kingfisher

final class UserMemoCollectionViewCell: UICollectionViewCell {
    static let id = "UserMemoCollectionViewCell"
    private let dataFormatManager = DateFormatManager.dataFormatManager
    
    // book data
    private let bookThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    // memo data
    private let memoTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 6
        label.lineBreakMode = .byCharWrapping
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    private let memoDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    public func configure(item: Memo) {
        let thumbnailURL = URL(string: item.book.thumbnail)
        
        bookThumbnailImageView.kf.setImage(with: thumbnailURL)
        bookTitleLabel.text = item.book.title
        
        memoTextLabel.text = item.memoText
        memoDateLabel.text = dataFormatManager.MemoDateToString(item.updatedAt)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserMemoCollectionViewCell {
    private func setupUI() {
        addSubview(bookThumbnailImageView)
        addSubview(bookTitleLabel)
        addSubview(memoTextLabel)
        addSubview(memoDateLabel)
        
        bookThumbnailImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalTo(120)
        }
        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(bookThumbnailImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
        }
        memoTextLabel.snp.makeConstraints { make in
            make.top.equalTo(bookTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(bookThumbnailImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
        }
        memoDateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
