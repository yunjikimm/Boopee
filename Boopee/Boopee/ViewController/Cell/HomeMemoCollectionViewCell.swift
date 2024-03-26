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
    private let dataFormatManager = DateFormatManager.dataFormatManager
    
    // blur effect background
    private let bookThumbnailEffectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let bookThumbnailEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        return visualEffectView
    }()
    
    // book data
    private let bookThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private let bookAuthorsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    private let bookPublisherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    // memo data
    private let memoTextBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private let memoTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    private let memoDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    public func configure(item: Memo) {
        let thumbnailURL = URL(string: item.book.thumbnail)
        
        bookThumbnailEffectImageView.kf.setImage(with: thumbnailURL)
        bookThumbnailImageView.kf.setImage(with: thumbnailURL)
        bookTitleLabel.text = item.book.title
        bookAuthorsLabel.text = item.book.authors
        bookPublisherLabel.text = item.book.publisher
        
        memoTextLabel.text = item.memoText
        memoDateLabel.text = dataFormatManager.MemoDateToString(item.updatedAt)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeMemoCollectionViewCell {
    private func setupUI() {
        addSubview(bookThumbnailEffectImageView)
        bookThumbnailEffectImageView.addSubview(bookThumbnailEffectView)
        
        bookThumbnailEffectImageView.addSubview(bookThumbnailImageView)
        bookThumbnailEffectImageView.addSubview(bookTitleLabel)
        bookThumbnailEffectImageView.addSubview(bookAuthorsLabel)
        bookThumbnailEffectImageView.addSubview(bookPublisherLabel)
        
        bookThumbnailEffectImageView.addSubview(memoTextBoxView)
        memoTextBoxView.addSubview(memoTextLabel)
        
        bookThumbnailEffectImageView.addSubview(memoDateLabel)
        
        bookThumbnailEffectImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        bookThumbnailEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bookThumbnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.centerX.equalToSuperview()
        }
        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bookThumbnailImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        bookAuthorsLabel.snp.makeConstraints { make in
            make.top.equalTo(bookTitleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        bookPublisherLabel.snp.makeConstraints { make in
            make.top.equalTo(bookAuthorsLabel.snp.bottom)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        memoTextBoxView.snp.makeConstraints { make in
            make.top.equalTo(bookPublisherLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalTo(memoDateLabel.snp.top).offset(-18)
        }
        memoTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        memoDateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
}
