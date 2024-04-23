//
//  EditUserNickNameViewController.swift
//  Boopee
//
//  Created by yunjikim on 4/4/24.
//

import UIKit
import RxSwift

class EditUserNickNameViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let updateButtonDidTapEvent = PublishSubject<Void>()
    private let userNickNameUpdateViewModel = UserNickNameUpdateViewModel()
    
    private let nickNameTextView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        textView.isScrollEnabled = false
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.backgroundColor = .customSecondarySystemBackground
        textView.layer.cornerRadius = CornerRadiusConstant.textView
        textView.font = .memoTextFont
        return textView
    }()
    private lazy var textLimitLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .tertiaryLabel
        label.textColor = .memoLimitLabelColor
        label.font = .memoLimitFont
        label.text = "\(self.nickNameTextView.text.count)/10"
        return label
    }()
    
    private let editUserNickNameButton: UIButton = {
        var button = UIButton(configuration: .plain())
        button.setTitle(ButtonConstant.done, for: .normal)
        button.tintColor = .disableButtonLabelColor
        button.backgroundColor = .customSecondarySystemBackground
        button.layer.cornerRadius = CornerRadiusConstant.button
        button.isEnabled = false
        return button
    }()
    private lazy var dismissBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissView))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = NavigationTitleConstant.updateNickname
        self.navigationItem.leftBarButtonItem = dismissBarButton
        
        nickNameTextView.delegate = self
        
        setupUI()
        bindMemoTextView()
        editUserNickNameButtonPressed()
        tapGesture()
    }
    
    public func config(userNickName: String) {
        nickNameTextView.text = userNickName
    }
}


// MARK: - bind edit user nickName Button
extension EditUserNickNameViewController {
    private func editUserNickNameButtonPressed() {
        editUserNickNameButton.rx.tap.bind { [weak self] _ in
            self?.bindEditUserNickNameButton()
        }.disposed(by: disposeBag)
    }
    
    private func bindEditUserNickNameButton() {
        Task {
            guard let nickName = nickNameTextView.text else { return }
            
            let input = UserNickNameUpdateViewModel.Input(updateButtonDidTapEvent: updateButtonDidTapEvent.asObserver())
            let output = await userNickNameUpdateViewModel.transform(input: input, nickName: nickName)
            
            output.isSuccessUpdateMemo.bind { [weak self] success in
                if success {
                    self?.dismiss(animated: true)
                } else {
                    print("Failed Update NickName.")
                }
            }.disposed(by: disposeBag)
        }
    }
}

// MARK: - dismiss button
extension EditUserNickNameViewController {
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
}

// MARK: - extension textView bind
private extension EditUserNickNameViewController {
    private func bindMemoTextView() {
        nickNameTextView.rx.didChange
            .bind {
                if !self.nickNameTextView.text.isEmpty {
                    self.editUserNickNameButton.isEnabled = true
                    self.editUserNickNameButton.setTitleColor(.enableButtonLabelColor, for: .normal)
                    self.editUserNickNameButton.backgroundColor = .pointGreen
                } else {
                    self.editUserNickNameButton.isEnabled = false
                    self.editUserNickNameButton.setTitleColor(.disableButtonLabelColor, for: .disabled)
                    self.editUserNickNameButton.backgroundColor = .customSecondarySystemBackground
                }
                
                if self.nickNameTextView.text.count > 10 {
                    self.nickNameTextView.text = String(self.nickNameTextView.text.prefix(10))
                } else {
                    self.textLimitLabel.text = "\(self.nickNameTextView.text.count)/10"
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: - extension keyboard
private extension EditUserNickNameViewController {
    private func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func endEditing() {
        self.view.endEditing(true)
    }
}

// MARK: - extension UITextViewDelegate
extension EditUserNickNameViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            view.endEditing(true)
            return false
        }
        return true
    }
}

// MARK: - setupUI
extension EditUserNickNameViewController {
    private func setupUI() {
        self.view.backgroundColor = .customSystemBackground
        
        self.view.addSubview(nickNameTextView)
        self.view.addSubview(editUserNickNameButton)
        self.view.addSubview(textLimitLabel)
        
        nickNameTextView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        textLimitLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextView.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        editUserNickNameButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(44)
        }
    }
}
