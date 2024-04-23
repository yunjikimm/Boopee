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
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    private let loginInstructionLabel: UILabel = {
        let label = UILabel()
        label.text = LoginInstructionConst.labelText
        label.numberOfLines = 0
        label.textAlignment = .center
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
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissView))
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
                    self.dismissView()
                }
            }
        }, for: .touchUpInside)
    }
}

// MARK: - dismiss button
extension LoginViewController {
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
}

// MARK: - setupUI
extension LoginViewController {
    private func setupUI() {
        self.view.backgroundColor = .customSystemBackground
        
        self.view.addSubview(loginWrapView)
        loginWrapView.addSubview(logoImageView)
        loginWrapView.addSubview(loginLabel)
        loginWrapView.addSubview(loginInstructionLabel)
        loginWrapView.addSubview(gidSignInButton)
        
        loginWrapView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset((self.view.frame.size.height / 2) / 2)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }
        loginInstructionLabel.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
        gidSignInButton.snp.makeConstraints { make in
            make.top.equalTo(loginInstructionLabel.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview()
        }
    }
}
