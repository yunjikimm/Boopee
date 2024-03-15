//
//  MyPageViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit
import RxSwift
import GoogleSignIn

class MyPageViewController: UIViewController {
    let signOutButtonTapped = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    let signInViewModel = SignInViewModel.signInViewModel
    let signOutViewModel = SignOutViewModel.signOutViewModel
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let authButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인하기", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃하기", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if signInViewModel.firebaseAuth.currentUser != nil {
            setUpHasCurrentUserUI()
            bindAuthViewModelSignOut()
        } else {
            setUpNilCurrentUserUI()
            tapAuthButton()
        }
    }
}

extension MyPageViewController {
    private func setUpHasCurrentUserUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(loginLabel)
        self.view.addSubview(signOutButton)
        loginLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        signOutButton.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        loginLabel.text = signInViewModel.firebaseAuth.currentUser?.email
    }
    
    private func bindAuthViewModelSignOut() {
        let input = SignOutViewModel.Input(signOutButtonTapped: signOutButton.rx.tap.asDriver())
        let output = signOutViewModel.transform(input: input)
        
        output.isSignOutSuccessSignal.drive { [weak self] _ in
            self?.viewDidLoad()
            print("my page sign out")
        }.disposed(by: disposeBag)
    }
}

extension MyPageViewController {
    private func setUpNilCurrentUserUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(authButton)
        authButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func tapAuthButton() {
        authButton.rx.tap
            .bind { [weak self] _ in
                let authViewController = SignInViewController()
                authViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self?.present(authViewController, animated: true)
            }.disposed(by: disposeBag)
    }
}
