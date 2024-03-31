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
extension EditMemoViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            view.endEditing(true)
            return false
        }
        return true
    }
}
