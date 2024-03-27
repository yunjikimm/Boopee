//
//  MemoDetailViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/27/24.
//

import UIKit
import RxSwift

final class MemoDetailViewController: UIViewController {
    let deleteMemoTrigger = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    let memoDeleteViewModel = MemoDeleteViewModel()
    private let dataFormatManager = DateFormatManager.dataFormatManager
    
    private var memoItem: Memo? = nil
    
    // book data
    private let bookThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let bookAuthorsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    private let bookPublisherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    // memo data
    private let memoTextBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 8
        return view
    }()
    private let memoTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    private let memoDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    private lazy var editMemoButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editMemoButtonPressed))
        return button
    }()
    private lazy var deleteMemoButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteMemoButtonPressed))
        return button
    }()
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setupUI()
        setNavigationBarButtonItems()
    }
    
    // MARK: - config()
    public func config(item: Memo) {
        let thumbnailURL = URL(string: item.book.thumbnail)
        
        bookThumbnailImageView.kf.setImage(with: thumbnailURL)
        bookTitleLabel.text = item.book.title
        bookAuthorsLabel.text = item.book.authors
        bookPublisherLabel.text = item.book.publisher
        
        memoTextLabel.text = item.memoText
        memoDateLabel.text = dataFormatManager.MemoDateToString(item.updatedAt)
        
        memoItem = item
    }
}

extension MemoDetailViewController {
    private func setNavigationBarButtonItems() {
        self.navigationItem.rightBarButtonItems = [editMemoButton, deleteMemoButton]
    }
    
    @objc private func editMemoButtonPressed() {
        let createBookMemoViewController = CreateBookMemoViewController()
        self.navigationController?.pushViewController(createBookMemoViewController, animated: true)
        guard let item = memoItem else { return }
        createBookMemoViewController.memoConfig(item: item)
    }
    
    @objc private func deleteMemoButtonPressed() {
        Task {
            guard let memo = memoItem, let uid = memo.id else { return }
            
            let input = MemoDeleteViewModel.Input(deleteMemoTrigger: deleteMemoTrigger.asObserver())
            let output = await memoDeleteViewModel.transform(input: input, uid: uid)
            
            output.deleteButtonDidTapEvent.bind { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("Failed Delete Memo.")
                }
            }.disposed(by: disposeBag)
        }
    }
}

extension MemoDetailViewController {
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(bookThumbnailImageView)
        self.view.addSubview(bookTitleLabel)
        self.view.addSubview(bookAuthorsLabel)
        self.view.addSubview(bookPublisherLabel)
        
        self.view.addSubview(memoTextBoxView)
        memoTextBoxView.addSubview(memoTextLabel)
        
        self.view.addSubview(memoDateLabel)
        
        bookThumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.height.equalTo(80)
        }
        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bookThumbnailImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        bookAuthorsLabel.snp.makeConstraints { make in
            make.top.equalTo(bookTitleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        bookPublisherLabel.snp.makeConstraints { make in
            make.top.equalTo(bookAuthorsLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        memoTextBoxView.snp.makeConstraints { make in
            make.top.equalTo(bookPublisherLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        memoTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        memoDateLabel.snp.makeConstraints { make in
            make.top.equalTo(memoTextBoxView.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
