//
//  LoginViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/14/24.
//

import UIKit
import GoogleSignIn

final class LoginViewController: UIViewController {
    private let loginViewModel = LoginViewModel()
    
    private let loginWrapView = UIView()
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    private let loginInstructionLabel: UILabel = {
        let label = UILabel()
        label.text = "서비스를 이용하시려면\n로그인을 해주세요!"
        label.numberOfLines = 0
        label.textColor = .emptyItemMessageLabelColor
        label.font = .emptyItemMessageFont
        return label
    }()
    private let gidSignInButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .wide
        button.colorScheme = .light
        return button
    }()
    private lazy var dismissBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(dismissLoginView))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = dismissBarButton
        
        setupUI()
        
        gidSignInButton.addAction(UIAction { _ in
            Task {
                try await self.loginViewModel.googleSignIn(viewController: self)
                
                if self.loginViewModel.loginUser != nil {
                    self.dismissLoginView()
                }
            }
        }, for: .touchUpInside)
    }
}

// MARK: - dismiss button
extension LoginViewController {
    @objc private func dismissLoginView() {
        self.dismiss(animated: true)
    }
}

// MARK: - setupUI
extension LoginViewController {
    private func setupUI() {
        self.view.backgroundColor = .customSystemBackground
        
        self.view.addSubview(logoLabel)
        self.view.addSubview(loginWrapView)
        loginWrapView.addSubview(loginInstructionLabel)
        loginWrapView.addSubview(gidSignInButton)
        
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(32)
            make.leading.equalToSuperview().offset(20)
        }
        loginWrapView.snp.makeConstraints { make in
            make.top.equalTo(logoLabel).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        loginInstructionLabel.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        gidSignInButton.snp.makeConstraints { make in
            make.top.equalTo(loginInstructionLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(loginWrapView.snp.bottom)
        }
    }
}
