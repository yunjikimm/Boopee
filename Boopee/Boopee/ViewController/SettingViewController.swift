//
//  SettingViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/28/24.
//

import UIKit
import RxSwift

class SettingViewController: UIViewController {
    let disposeBag = DisposeBag()
    let loginViewModel = LoginViewModel()
    
    private let userInfoBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        return view
    }()
    private let userEmailLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let serviceUsageGuideButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitle(SettingItemConstant.serviceUsageGuide.rawValue, for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 8
        return button
    }()
    private let privacyPolicyButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitle(SettingItemConstant.privacyPolicy.rawValue, for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 8
        return button
    }()
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "설정"
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        setupUI()
        userInfoConfig()
        bindSignOutButton()
        bindLinkButton()
    }
    
    private func userInfoConfig() {
        userEmailLabel.text = loginViewModel.firebaseAuth.currentUser?.email
    }
}

extension SettingViewController {
    private func bindSignOutButton() {
        signOutButton.rx.tap.bind { [weak self] in
            self?.loginViewModel.signOut()
        }.disposed(by: disposeBag)
    }
    
    private func bindLinkButton() {
        serviceUsageGuideButton.rx.tap.bind { [weak self] in
            let webViewController = WebViewController()
            webViewController.url = URL(string: SettingItemConstant.serviceUsageGuide.url)
            self?.present(webViewController, animated: true)
        }.disposed(by: disposeBag)
        
        privacyPolicyButton.rx.tap.bind { [weak self] in
            let webViewController = WebViewController()
            webViewController.url = URL(string: SettingItemConstant.privacyPolicy.url)
            self?.present(webViewController, animated: true)
        }.disposed(by: disposeBag)
        
    }
}

extension SettingViewController {
    private func setupUI() {
        self.view.backgroundColor = .secondarySystemBackground
        
        self.view.addSubview(userInfoBoxView)
        userInfoBoxView.addSubview(userEmailLabel)
        
        self.view.addSubview(serviceUsageGuideButton)
        self.view.addSubview(privacyPolicyButton)
        
        self.view.addSubview(signOutButton)
        
        userInfoBoxView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(70)
        }
        userEmailLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userInfoBoxView.snp.centerY)
            make.leading.equalTo(userInfoBoxView.snp.leading).offset(20)
        }
        
        serviceUsageGuideButton.snp.makeConstraints { make in
            make.top.equalTo(userInfoBoxView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(70)
        }
        privacyPolicyButton.snp.makeConstraints { make in
            make.top.equalTo(serviceUsageGuideButton.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(70)
        }
        
        signOutButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(54)
        }
    }
}
