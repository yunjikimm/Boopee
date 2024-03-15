//
//  SignInViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/14/24.
//

import UIKit
import RxSwift
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController {
    let googleLoginButtonTapped = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    let signInViewModel = SignInViewModel.signInViewModel
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .label
        return button
    }()
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
        bindAuthViewModel()
        
        dismissButton.rx.tap.bind { [weak self] _ in
            self?.dismissButtonTapped()
        }.disposed(by: disposeBag)
    }
    
    private func bindAuthViewModel() {
        let input = SignInViewModel.Input(googleLoginButtonTapped: googleLoginButton.rx.tap.asSignal())
        let output = signInViewModel.transform(input: input, viewController: self)
        
//        output.isLoginSuccessSignal.emit { [weak self] _ in
//            self?.dismissButtonTapped()
//        }.disposed(by: disposeBag)
        
//        output.isLoginSuccessSignal.emit(onCompleted:  {
//            self.dismissButtonTapped()
//        }).disposed(by: disposeBag)
    }
    
    private func setUpGoogleLoginUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(dismissButton)
        self.view.addSubview(loginInstructionLabel)
        self.view.addSubview(gidSignInButton)
        gidSignInButton.addSubview(googleLoginButton)
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(12)
        }
        loginInstructionLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        gidSignInButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        googleLoginButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func dismissButtonTapped() {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
}
