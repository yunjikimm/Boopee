//
//  LoginViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/14/24.
//

import UIKit
import Firebase
import GoogleSignIn

final class LoginViewController: UIViewController {
    private let loginViewModel = LoginViewModel.loginViewModel
    
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
        label.textAlignment = .center
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGoogleLoginUI()
        
        gidSignInButton.addAction(UIAction { _ in
            self.loginViewModel.googleSignIn(viewController: self)
        }, for: .touchUpInside)
    }
    
    private func setUpGoogleLoginUI() {
        self.view.backgroundColor = .customSystemBackground
        
        self.view.addSubview(loginWrapView)
        loginWrapView.addSubview(logoLabel)
        loginWrapView.addSubview(loginInstructionLabel)
        loginWrapView.addSubview(gidSignInButton)
        
        loginWrapView.snp.makeConstraints { make in
            make.centerY.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(loginWrapView.snp.top)
            make.centerX.equalToSuperview()
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
