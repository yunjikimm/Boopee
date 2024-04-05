//
//  EditMemoViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/9/24.
//

import UIKit
import RxSwift
import Firebase

final class EditMemoViewController: UIViewController {
    private let createButtonDidTapEvent = PublishSubject<Void>()
    private let updateButtonDidTapEvent = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let memoCreateViewModel = MemoCreateViewModel()
    private let memoUpdateViewModel = MemoUpdateViewModel()
    
    private var bookItem: Book?
    private var memoItem: Memo?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let scrollContentView = UIView()
    
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
        label.textColor = .bookTitleLabelColor
        label.font = .bookTitleFont
        return label
    }()
    private let bookAuthorsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .bookAuthorLabelColor
        label.font = .bookAuthorsFont
        return label
    }()
    private let bookPublisherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .bookPublisherLabelColor
        label.font = .bookPublisherFont
        return label
    }()
    
    private let memoTextView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        textView.isScrollEnabled = false
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.backgroundColor = .customSecondarySystemBackground
        textView.layer.cornerRadius = CornerRadiusConstant.textView
        textView.text = InitMemoTextViewConst.memoTextPlaceholder
        textView.textColor = .memoTextPlaceholderLabelColor
        textView.font = .memoTextFont
        return textView
    }()
    
    private let memoLimitLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .tertiaryLabel
        label.textColor = .memoLimitLabelColor
        label.font = .memoLimitFont
        label.text = "0/\(InitMemoTextViewConst.memoTextMaxLength)"
        return label
    }()
    
    private let writeMemoButton: UIButton = {
        var button = UIButton(configuration: .plain())
        button.setTitle("완료", for: .normal)
        button.tintColor = .disableButtonLabelColor
        button.backgroundColor = .customSecondarySystemBackground
        button.layer.cornerRadius = CornerRadiusConstant.button
        button.isEnabled = false
        return button
    }()
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
        memoTextView.delegate = self
        
        registerKeyboardNotification()
        
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
        
        bookThumbnailImageView.kf.setImage(with: URL(string: item.thumbnail))
        bookTitleLabel.text = item.title
        bookAuthorsLabel.text = item.authors
        bookPublisherLabel.text = item.publisher
        
        self.navigationItem.title = EditMemoNavigationTitleConstant.create.rawValue
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
        
        self.navigationItem.title = EditMemoNavigationTitleConstant.update.rawValue
    }
}

// MARK: - setup ui
private extension EditMemoViewController {
    // MARK: - setupUI()
    private func setupUI() {
        self.view.backgroundColor = .customSystemBackground
        self.view.clipsToBounds = true
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(bookThumbnailImageView)
        
        scrollContentView.addSubview(bookTitleLabel)
        scrollContentView.addSubview(bookAuthorsLabel)
        scrollContentView.addSubview(bookPublisherLabel)
        
        scrollContentView.addSubview(memoTextView)
        scrollContentView.addSubview(memoLimitLabel)
        
        scrollContentView.addSubview(writeMemoButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        scrollContentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(scrollView.snp.height)
        }
        
        bookThumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(scrollContentView.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalTo(76)
            make.height.equalTo(100)
        }
        
        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bookThumbnailImageView.snp.bottom).offset(4)
            make.leading.trailing.centerX.equalToSuperview()
        }
        bookAuthorsLabel.snp.makeConstraints { make in
            make.top.equalTo(bookTitleLabel.snp.bottom).offset(4)
            make.leading.trailing.centerX.equalToSuperview()
        }
        bookPublisherLabel.snp.makeConstraints { make in
            make.top.equalTo(bookAuthorsLabel.snp.bottom)
            make.leading.trailing.centerX.equalToSuperview()
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(bookPublisherLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        memoLimitLabel.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        
        writeMemoButton.snp.makeConstraints { make in
            make.top.equalTo(memoLimitLabel.snp.bottom).offset(4)
            make.leading.trailing.centerX.equalToSuperview()
            make.bottom.equalTo(scrollContentView.snp.bottom).offset(-12)
            make.height.equalTo(44)
        }
    }
    
}

// MARK: - extension button bind
private extension EditMemoViewController {
    private func createMemoButtonPressed() {
        writeMemoButton.rx.tap.bind {
            self.bindMemoCreateButton()
        }.disposed(by: disposeBag)
    }
    
    private func bindMemoCreateButton() {
        guard let user = Auth.auth().currentUser?.uid,
              let book = bookItem,
              let createMemoText = memoTextView.text else { return }
        
        let memo = Memo(id: UUID().uuidString, user: user, memoText: createMemoText, createdAt: Date(), updatedAt: Date(), book: book)
        
        let input = MemoCreateViewModel.Input(createButtonDidTapEvent: createButtonDidTapEvent.asObservable())
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
private extension EditMemoViewController {
    private func bindMemoTextView() {
        memoTextView.rx.didChange
            .bind {
                let size = CGSize(width: self.view.frame.width, height: .infinity)
                let estimatedSize = self.memoTextView.sizeThatFits(size)
                
                self.memoTextView.constraints.forEach { constraint in
                    if constraint.firstAttribute == .height {
                        constraint.constant = estimatedSize.height
                    }
                }
                
                if !self.memoTextView.text.isEmpty {
                    self.writeMemoButton.isEnabled = true
                    self.writeMemoButton.setTitleColor(.enableButtonLabelColor, for: .normal)
                    self.writeMemoButton.backgroundColor = .pointGreen
                } else {
                    self.writeMemoButton.isEnabled = false
                    self.writeMemoButton.setTitleColor(.disableButtonLabelColor, for: .disabled)
                    self.writeMemoButton.backgroundColor = .customSecondarySystemBackground
                }
                
                if self.memoTextView.text.count > InitMemoTextViewConst.memoTextMaxLength {
                    self.memoTextView.text = String(self.memoTextView.text.prefix(InitMemoTextViewConst.memoTextMaxLength))
                } else {
                    self.memoLimitLabel.text = "\(self.memoTextView.text.count)/\(InitMemoTextViewConst.memoTextMaxLength)"
                }
            }.disposed(by: disposeBag)
        
        memoTextView.rx.didBeginEditing
            .bind {
                if self.memoTextView.textColor == .memoTextPlaceholderLabelColor {
                    self.memoTextView.text = nil
                    self.memoTextView.textColor = .memoTextLabelColor
                }
            }.disposed(by: disposeBag)
        
        memoTextView.rx.didEndEditing
            .bind {
                if self.memoTextView.text.isEmpty {
                    self.memoTextView.text = InitMemoTextViewConst.memoTextPlaceholder
                    self.memoTextView.textColor = .memoTextPlaceholderLabelColor
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: - extension keyboard
private extension EditMemoViewController {
    private func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func registerKeyboardNotification() {
        let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
        
        keyboardWillShow.bind { [weak self] notification in
            guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            self?.scrollView.contentInset = contentInset
        }.disposed(by: disposeBag)
        
        keyboardWillHide.bind { [weak self] _ in
            let contentInset = UIEdgeInsets.zero
            self?.scrollView.contentInset = contentInset
            self?.scrollView.setContentOffset(.zero, animated: true)
        }.disposed(by: disposeBag)
    }
    
    @objc private func endEditing() {
        self.view.endEditing(true)
    }
}

// MARK: - extension UITextViewDelegate
extension EditMemoViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            view.endEditing(true)
            return false
        }
        return true
    }
}
