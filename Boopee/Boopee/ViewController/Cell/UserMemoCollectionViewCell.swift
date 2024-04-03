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
    
    private lazy var memoWrapStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    private let memoInfoBoxView = UIView()
    private let bookThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .bookTitleLabelColor
        label.font = .bookTitleFont
        return label
    }()
    private let memoTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.lineBreakMode = .byCharWrapping
        label.textColor = .memoTextPreviewLabelColor
        label.font = .memoTextPreviewFont
        return label
    }()
    private let memoDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .memoDateLabelColor
        label.font = .memoDateFont
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    public func configure(item: Memo) {
        bookThumbnailImageView.kf.setImage(with: URL(string: item.book.thumbnail))
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
        addSubview(memoWrapStackView)
        memoWrapStackView.addArrangedSubview(bookThumbnailImageView)
        memoWrapStackView.addArrangedSubview(memoInfoBoxView)
        
        memoInfoBoxView.addSubview(bookTitleLabel)
        memoInfoBoxView.addSubview(memoTextLabel)
        memoInfoBoxView.addSubview(memoDateLabel)
        
        memoWrapStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        bookThumbnailImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(144)
        }
        
        memoInfoBoxView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.bottom.equalTo(memoWrapStackView.snp.bottom)
        }
        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalTo(memoInfoBoxView.snp.leading)
            make.trailing.equalToSuperview()
        }
        memoTextLabel.snp.makeConstraints { make in
            make.top.equalTo(bookTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(memoInfoBoxView.snp.leading)
            make.trailing.equalToSuperview()
        }
        memoDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(memoInfoBoxView.snp.leading)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(memoInfoBoxView.snp.bottom).offset(-4)
        }
    }
}
