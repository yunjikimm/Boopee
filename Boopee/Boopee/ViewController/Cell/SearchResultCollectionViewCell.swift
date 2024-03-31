//
//  SearchResultCollectionViewCell.swift
//  Boopee
//
//  Created by yunjikim on 3/5/24.
//

import UIKit
import Kingfisher

final class SearchResultCollectionViewCell: UICollectionViewCell {
    static let id = "SearchResultCollectionViewCell"
    
    private lazy var searchResultThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private let searchResultTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .bookTitleLabelColor
        label.font = .bookTitleFont
        return label
    }()
    private let searchResultAuthorsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .bookAuthorLabelColor
        label.font = .bookAuthorsFont
        return label
    }()
    private let searchResultPublisherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .bookPublisherLabelColor
        label.font = .bookPublisherFont
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        addSubview(searchResultThumbnailImageView)
        addSubview(searchResultTitleLabel)
        addSubview(searchResultAuthorsLabel)
        addSubview(searchResultPublisherLabel)
        
        searchResultThumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        searchResultTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchResultThumbnailImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
        searchResultAuthorsLabel.snp.makeConstraints { make in
            make.top.equalTo(searchResultTitleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        searchResultPublisherLabel.snp.makeConstraints { make in
            make.top.equalTo(searchResultAuthorsLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
    public func configure(item: Book) {
        let thumbnailURL = URL(string: item.thumbnail)
        
        searchResultThumbnailImageView.kf.setImage(with: thumbnailURL)
        searchResultTitleLabel.text = item.title
        searchResultAuthorsLabel.text = item.authors
        searchResultPublisherLabel.text = item.publisher
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
