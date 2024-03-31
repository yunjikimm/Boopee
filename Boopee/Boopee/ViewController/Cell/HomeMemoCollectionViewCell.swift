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
    
    // book data
    private let bookInfoWrapStackViewView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .top
        stackView.distribution = .fill
        return stackView
    }()
    private let bookInfoTextBoxView: UIView = {
        let view = UIView()
        return view
    }()
    private let bookThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .bookTitleLabelColor
        label.font = .bookTitleFont
        return label
    }()
    private let bookAuthorsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .bookAuthorLabelColor
        label.font = .bookAuthorsFont
        return label
    }()
    private let bookPublisherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .bookPublisherLabelColor
        label.font = .bookPublisherFont
        return label
    }()
    
    // memo data
    private let memoTextBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = .customSecondarySystemBackground
        view.layer.cornerRadius = CornerRadiusConstant.textView
        return view
    }()
    private let memoTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.textColor = .memoTextLabelColor
        label.font = .memoTextFont
        return label
    }()
    private let memoDateLabel: UILabel = {
        let label = UILabel()
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
        contentView.backgroundColor = .customSystemBackground
        contentView.layer.cornerRadius = CornerRadiusConstant.memoBoxView
        
        addSubview(bookInfoWrapStackViewView)
        bookInfoWrapStackViewView.addArrangedSubview(bookInfoTextBoxView)
        bookInfoWrapStackViewView.addArrangedSubview(bookThumbnailImageView)
        
        bookInfoTextBoxView.addSubview(bookTitleLabel)
        bookInfoTextBoxView.addSubview(bookAuthorsLabel)
        bookInfoTextBoxView.addSubview(bookPublisherLabel)
        
        addSubview(memoTextBoxView)
        memoTextBoxView.addSubview(memoTextLabel)
        memoTextBoxView.addSubview(memoDateLabel)
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        bookInfoWrapStackViewView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
        bookInfoTextBoxView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.trailing.equalTo(bookThumbnailImageView.snp.leading).offset(-4)
        }
        bookTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        bookAuthorsLabel.snp.makeConstraints { make in
            make.top.equalTo(bookTitleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
        bookPublisherLabel.snp.makeConstraints { make in
            make.top.equalTo(bookAuthorsLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        bookThumbnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(76)
            make.height.equalTo(100)
        }
        
        memoTextBoxView.snp.makeConstraints { make in
            make.top.equalTo(bookInfoWrapStackViewView.snp.bottom).offset(12)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-30)
        }
        memoTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        memoDateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
    }
}
