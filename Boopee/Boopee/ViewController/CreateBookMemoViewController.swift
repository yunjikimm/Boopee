//
//  CreateBookMemoViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/9/24.
//

import UIKit

class CreateBookMemoViewController: UIViewController {
    private let stackView = UIStackView()
    private let textStackView = UIStackView()
    private let searchResultThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private let searchResultTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.backgroundColor = .black
        label.textColor = .white
        return label
    }()
    private let searchResultAuthorsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.backgroundColor = .black
        label.textColor = .white
        return label
    }()
    private let searchResultPublisherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.backgroundColor = .black
        label.textColor = .white
        return label
    }()
    
    private let memoTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isScrollEnabled = false
        textView.backgroundColor = .lightGray
        return textView
    }()
    private let createMemoButton: UIButton = {
        let button = UIButton()
        button.setTitle("메모 작성하기", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.tabBarController?.tabBar.isHidden = true
        
        setupUI()
    }
    
    private func setupUI() {
        self.view.addSubview(stackView)
        
        stackView.addArrangedSubview(searchResultThumbnailImageView)
        stackView.addArrangedSubview(textStackView)
        
        textStackView.addSubview(searchResultTitleLabel)
        textStackView.addSubview(searchResultAuthorsLabel)
        textStackView.addSubview(searchResultPublisherLabel)
        
        self.view.addSubview(memoTextView)
        self.view.addSubview(createMemoButton)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
        }
        
        searchResultThumbnailImageView.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.leading)
            make.width.equalTo(100)
        }
        textStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-4)
            make.leading.equalTo(searchResultThumbnailImageView.snp.trailing)
        }
        
        searchResultTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchResultThumbnailImageView.snp.trailing)
        }
        searchResultAuthorsLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchResultThumbnailImageView.snp.trailing)
            make.top.equalTo(searchResultTitleLabel.snp.bottom)
        }
        searchResultPublisherLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchResultThumbnailImageView.snp.trailing)
            make.top.equalTo(searchResultAuthorsLabel.snp.bottom)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(4)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-4)
        }
        createMemoButton.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(4)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-4)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    public func config(item: Document) {
        let thumbnailURL = URL(string: item.thumbnail)
        
        searchResultThumbnailImageView.kf.setImage(with: thumbnailURL)
        searchResultTitleLabel.text = item.title
        searchResultAuthorsLabel.text = item.authors
        searchResultPublisherLabel.text = item.publisher
    }

}
