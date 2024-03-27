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
    let updateButtonDidTapEvent = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    let memoCreateViewModel = MemoCreateViewModel()
    let memoUpdateViewModel = MemoUpdateViewModel()
    private var bookItem: Book?
    private var memoItem: Memo?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
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
    
    let memoTextView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 8
        textView.text = InitMemoTextViewConst.memoTextPlaceholder
        textView.textColor = InitMemoTextViewConst.memoTextColor
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        return textView
    }()
    
    private let memoLimitLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tertiaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "0/\(InitMemoTextViewConst.memoTextMaxLength)"
        return label
    }()
    
    private let writeMemoButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
        memoTextView.delegate = self
        
        if bookItem != nil && memoItem == nil {
            createMemoButtonPressed()
        } else if bookItem == nil && memoItem != nil {
            updateMemoButtonPressed()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        bindMemoTextView()
        tapGesture()
    }
    
    // MARK: - config()
    public func config(item: Book) {
        bookItem = item
        let thumbnailURL = URL(string: item.thumbnail)
        
        bookThumbnailImageView.kf.setImage(with: thumbnailURL)
        bookTitleLabel.text = item.title
        bookAuthorsLabel.text = item.authors
        bookPublisherLabel.text = item.publisher
        
        self.navigationItem.title = "작성하기"
    }
    
    public func memoConfig(item: Memo) {
        memoItem = item
        let thumbnailURL = URL(string: item.book.thumbnail)
        
        bookThumbnailImageView.kf.setImage(with: thumbnailURL)
        bookTitleLabel.text = item.book.title
        bookAuthorsLabel.text = item.book.authors
        bookPublisherLabel.text = item.book.publisher
        
        memoTextView.text = item.memoText
        memoTextView.textColor = .label
        
        memoLimitLabel.text = "\(memoTextView.text.count)/\(InitMemoTextViewConst.memoTextMaxLength)"
        
        self.navigationItem.title = "수정하기"
    }
}

// MARK: - setup ui
private extension CreateBookMemoViewController {
    // MARK: - setupUI()
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(bookThumbnailImageView)
        
        scrollView.addSubview(bookTitleLabel)
        scrollView.addSubview(bookAuthorsLabel)
        scrollView.addSubview(bookPublisherLabel)
        
        scrollView.addSubview(memoTextView)
        scrollView.addSubview(memoLimitLabel)
        scrollView.addSubview(writeMemoButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        bookThumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
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
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(bookPublisherLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(275)
        }
        memoLimitLabel.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(12)
            make.trailing.equalToSuperview()
        }
        
        writeMemoButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(54)
        }
    }
    
}

// MARK: - extension button bind
private extension CreateBookMemoViewController {
    private func createMemoButtonPressed() {
        writeMemoButton.rx.tap.bind {
            self.bindMemoCreateButton()
        }.disposed(by: disposeBag)
    }
    
    private func bindMemoCreateButton() {
        guard let user = Auth.auth().currentUser?.uid else { return }
        guard let book = bookItem else { return }
        
        let memo = Memo(id: UUID().uuidString, user: user, memoText: "", createdAt: Date(), updatedAt: Date(), book: book)
        
        let input = MemoCreateViewModel.Input(createButtonDidTapEvent: writeMemoButton.rx.tap.asObservable(), memoText: memoTextView.rx.text.asObservable())
        let output = memoCreateViewModel.transform(input: input, memo: memo)
        
        output.isSuccessCreateMemo
            .bind { success in
                if success {
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    print("Failed Create Memo.")
                }
            }.disposed(by: disposeBag)
    }
    
    private func updateMemoButtonPressed() {
        writeMemoButton.rx.tap.bind {
            self.bindMemoUpdateButton()
        }.disposed(by: disposeBag)
    }
    
    private func bindMemoUpdateButton() {
        Task {
            guard let memo = memoItem,
                  let uid = memo.id,
                  let updateMemoText = memoTextView.text else { return }
            
            let input = MemoUpdateViewModel.Input(updateButtonDidTapEvent: updateButtonDidTapEvent.asObservable())
            let output = await memoUpdateViewModel.transform(input: input, memo: memo, uid: uid, text: updateMemoText)
            
            output.isSuccessUpdateMemo
                .bind { success in
                    if success {
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        print("Failed Update Memo.")
                    }
                }.disposed(by: disposeBag)
        }
    }
}

// MARK: - extension textView bind
private extension CreateBookMemoViewController {
    private func bindMemoTextView() {
        memoTextView.rx.didChange
            .bind {
                if !self.memoTextView.text.isEmpty {
                    self.writeMemoButton.isEnabled = true
                    self.writeMemoButton.setTitleColor(.white, for: .normal)
                    self.writeMemoButton.backgroundColor = .black
                } else {
                    self.writeMemoButton.isEnabled = false
                    self.writeMemoButton.backgroundColor = .secondarySystemBackground
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
