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
    let disposeBag = DisposeBag()
    let signInViewModel = SignInViewModel.signInViewModel
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃하기", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpHasCurrentUserUI()
        bindAuthViewModelSignOut()
    }
    
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
        signOutButton.rx.tap
            .bind { _ in
                self.signInViewModel.signOut()
            }.disposed(by: disposeBag)
    }
}
