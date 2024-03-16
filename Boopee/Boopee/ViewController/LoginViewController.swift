//
//  LoginViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/14/24.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    let loginViewModel = LoginViewModel.loginViewModel
    
    private let loginInstructionLabel: UILabel = {
        let label = UILabel()
        label.text = "서비스를 이용하시려면\n로그인을 해주시기 바랍니다."
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    private let googleLoginButton: UIButton = {
        let button = UIButton()
        return button
    }()
    private let gidSignInButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .wide
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
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(loginInstructionLabel)
        self.view.addSubview(gidSignInButton)
        
        loginInstructionLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        gidSignInButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
}
