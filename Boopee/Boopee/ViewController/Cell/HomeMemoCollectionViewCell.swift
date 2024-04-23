//
//  HomeMemoCollectionViewCell.swift
//  Boopee
//
//  Created by yunjikim on 3/26/24.
//

import UIKit
import RxSwift
import Kingfisher

final class HomeMemoCollectionViewCell: UICollectionViewCell {
    static let id = "HomeMemoCollectionViewCell"
    
    private let getUserNickNameTrigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let userNickNameGetViewModel = UserNickNameGetViewModel()
    private let dataFormatManager = DateFormatManager.dataFormatManager
    
    // book data
    private let bookInfoWrapStackViewView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 4
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
        view.backgroundColor = .customSystemBackground
        view.layer.cornerRadius = CornerRadiusConstant.homeMemoBoxView
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
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayThree
        return view
    }()
    private let userNickNameLabel: UILabel = {
        let label = UILabel()
        label.text = NicknameConstant.empty
        label.textColor = .label
        label.font = .mediumBold
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
    
    public func configure(memo: Memo) {
        bookThumbnailImageView.kf.setImage(with: URL(string: memo.book.thumbnail))
        bookTitleLabel.text = memo.book.title
        bookAuthorsLabel.text = memo.book.authors
        bookPublisherLabel.text = memo.book.publisher
        
        memoTextLabel.text = memo.memoText
        memoDateLabel.text = dataFormatManager.MemoDateToString(memo.updatedAt)
        
        getUserInfo(userUid: memo.user)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - bind user info
extension HomeMemoCollectionViewCell {
    private func getUserInfo(userUid: String) {
        Task {
            let input = UserNickNameGetViewModel.Input(getUserNickNameTrigger: self.getUserNickNameTrigger.asObserver())
            let output = await self.userNickNameGetViewModel.transform(input: input, userUid: userUid)
            
            output.userNickName.bind { [weak self] nickName in
                self?.userNickNameLabel.text = nickName
            }.disposed(by: disposeBag)
        }
    }
}

// MARK: - setupUI
extension HomeMemoCollectionViewCell {
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        addSubview(bookInfoWrapStackViewView)
        bookInfoWrapStackViewView.addArrangedSubview(bookInfoTextBoxView)
        bookInfoWrapStackViewView.addArrangedSubview(bookThumbnailImageView)
        
        bookInfoTextBoxView.addSubview(bookTitleLabel)
        bookInfoTextBoxView.addSubview(bookAuthorsLabel)
        bookInfoTextBoxView.addSubview(bookPublisherLabel)
        
        addSubview(memoTextBoxView)
        memoTextBoxView.addSubview(memoTextLabel)
        
        memoTextBoxView.addSubview(underLineView)
        memoTextBoxView.addSubview(userNickNameLabel)
        memoTextBoxView.addSubview(memoDateLabel)
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        bookInfoWrapStackViewView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(contentView.snp.leading).offset(4)
            make.trailing.equalTo(contentView.snp.trailing).offset(-2)
        }
        bookInfoTextBoxView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
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
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom).offset(-4)
        }
        memoTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        underLineView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(userNickNameLabel.snp.top).offset(-12)
            make.height.equalTo(1)
        }
        userNickNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(17)
            make.bottom.equalToSuperview().offset(-16)
        }
        memoDateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-17)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}

