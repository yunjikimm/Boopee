//
//  CreateBookMemoViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/9/24.
//

import UIKit
import RxSwift
import Firebase

final class CreateBookMemoViewController: UIViewController {
    let disposeBag = DisposeBag()
    let memoCreateViewModel = MemoCreateViewModel()
    private var bookItem: Book?
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.tabBarController?.tabBar.isHidden = true
        memoTextView.delegate = self
        
        setupUI()
        bindMemoTextView()
        bindMemoCreateButton()
        tapGesture()
    }
    
    // MARK: - 프로퍼티
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let searchResultThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private let searchResultTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let searchResultAuthorsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    private let searchResultPublisherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    let memoTextView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 8, bottom: 15, right: 8)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 12
        textView.text = InitMemoTextViewConst.memoTextPlaceholder
        textView.textColor = InitMemoTextViewConst.memoTextColor
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        return textView
    }()
    
    private let memoLimitLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tertiaryLabel
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.text = "0/\(InitMemoTextViewConst.memoTextMaxLength)"
        return label
    }()
    
    private let createMemoButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 12
        button.isEnabled = false
        return button
    }()
    
    // MARK: - setupUI()
    private func setupUI() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(searchResultThumbnailImageView)
        
        scrollView.addSubview(searchResultTitleLabel)
        scrollView.addSubview(searchResultAuthorsLabel)
        scrollView.addSubview(searchResultPublisherLabel)
        
        scrollView.addSubview(memoTextView)
        scrollView.addSubview(memoLimitLabel)
        scrollView.addSubview(createMemoButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
        }
        
        searchResultThumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalTo(80)
        }
        
        searchResultTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchResultThumbnailImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        searchResultAuthorsLabel.snp.makeConstraints { make in
            make.top.equalTo(searchResultTitleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        searchResultPublisherLabel.snp.makeConstraints { make in
            make.top.equalTo(searchResultAuthorsLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(searchResultPublisherLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        memoLimitLabel.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(2)
            make.trailing.equalToSuperview()
        }
        
        createMemoButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(54)
        }
    }
    
    // MARK: - config()
    public func config(item: Book) {
        bookItem = item
        let thumbnailURL = URL(string: item.thumbnail)
        
        searchResultThumbnailImageView.kf.setImage(with: thumbnailURL)
        searchResultTitleLabel.text = item.title
        searchResultAuthorsLabel.text = item.authors
        searchResultPublisherLabel.text = item.publisher
    }

}

// MARK: - extension button bind
private extension CreateBookMemoViewController {
    private func bindMemoCreateButton() {
        guard let user = Auth.auth().currentUser?.uid else { return }
//        guard let memoText = memoTextView.text else { return }
        guard let book = bookItem else { return }
        let memo = Memo(id: UUID().uuidString, user: user, memoText: "", createdAt: Date(), updatedAt: Date(), book: book)
        
        let input = MemoCreateViewModel.Input(createButtonDidTapEvent: createMemoButton.rx.tap.asObservable(), memoText: memoTextView.rx.text.asObservable())
        let output = memoCreateViewModel.transform(input: input, memo: memo)
        
        output.isSuccessCreateMemo
            .bind { success in
                if success {
                    print("Success Create Memo...")
                } else {
                    print("Failed Create Memo...")
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: - extension textView bind
private extension CreateBookMemoViewController {
    private func bindMemoTextView() {
        memoTextView.rx.didChange
            .bind {
                if self.memoTextView.text != ""  {
                    self.createMemoButton.isEnabled = true
                    self.createMemoButton.setTitleColor(.systemBackground, for: .normal)
                    self.createMemoButton.backgroundColor = .black
                } else {
                    self.createMemoButton.isEnabled = false
                    self.createMemoButton.backgroundColor = .secondarySystemBackground
                }
                
                if self.memoTextView.text.count > InitMemoTextViewConst.memoTextMaxLength {
                    self.memoTextView.text = String(self.memoTextView.text.prefix(InitMemoTextViewConst.memoTextMaxLength))
                } else {
                    self.memoLimitLabel.text = "\(self.memoTextView.text.count)/\(InitMemoTextViewConst.memoTextMaxLength)"
                }
            }.disposed(by: disposeBag)
        
        memoTextView.rx.didBeginEditing
            .bind {
                if self.memoTextView.textColor == InitMemoTextViewConst.memoTextColor {
                    self.memoTextView.text = nil
                    self.memoTextView.textColor = .label
                }
            }.disposed(by: disposeBag)
        
        memoTextView.rx.didEndEditing
            .bind {
                if self.memoTextView.text == nil {
                    self.memoTextView.text = InitMemoTextViewConst.memoTextPlaceholder
                    self.memoTextView.textColor = .lightGray
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: - extension keyboard
private extension CreateBookMemoViewController {
    func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
}

// MARK: - extension UITextViewDelegate
extension CreateBookMemoViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            view.endEditing(true)
            return false
        }
        return true
    }
}
