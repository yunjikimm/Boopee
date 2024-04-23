//
//  SettingViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/28/24.
//

import UIKit
import RxSwift

final class SettingViewController: UIViewController {
    private let userInfoTrigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let userInfoViewModel = UserInfoViewModel()
    private let loginViewModel = LoginViewModel()
    
    private let userInfoStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .customSystemBackground
        view.layer.cornerRadius = CornerRadiusConstant.wrapView
        view.axis = .horizontal
        return view
    }()
    private let userInfoView = UIView()
    private let userInfoNickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임 없음"
        label.numberOfLines = 0
        label.font = .largeBold
        return label
    }()
    private let userInfoEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "서비스를 이용하시려면 로그인을 해주세요!"
        label.numberOfLines = 0
        label.font = .mediumRegular
        return label
    }()
    private lazy var editUserInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil.line"), for: .normal)
        button.tintColor = .grayOne
        
        if self.loginViewModel.firebaseAuth.currentUser != nil {
            button.isEnabled = true
        } else {
            button.isEnabled = false
        }
        
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SettingItemTableViewCell.self, forCellReuseIdentifier: SettingItemTableViewCell.id)
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let signOutButton: UIButton = {
        var button = UIButton(configuration: .plain())
        button.setTitle("로그아웃", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = CornerRadiusConstant.button
        return button
    }()
    
    private lazy var settingItemList = [SettingItemConstant.serviceUsageGuide.rawValue, SettingItemConstant.privacyPolicy.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "설정"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
        bindSignOutButton()
        bindEditUserInfoButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
        getUserInfo()
    }
}

// MARK: - button action
extension SettingViewController {
    private func bindSignOutButton() {
        signOutButton.rx.tap.bind { [weak self] in
            self?.deleteMemoAlertAction()
        }.disposed(by: disposeBag)
    }
    
    private func signOutAction() {
        Task {
            let signOut = try await self.loginViewModel.signOut()
            
            if signOut {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func bindEditUserInfoButton() {
        editUserInfoButton.rx.tap.bind { [weak self] in
            guard let userNickName = self?.userInfoNickNameLabel.text else { return }
            let editUserNickNameViewController = EditUserNickNameViewController()
            
            editUserNickNameViewController.config(userNickName: userNickName)
            
            let navigationController = UINavigationController(rootViewController: editUserNickNameViewController)
            navigationController.modalPresentationStyle = .fullScreen
            
            self?.present(navigationController, animated: true)
        }.disposed(by: disposeBag)
    }
}

// MARK: - bind user info
extension SettingViewController {
    private func getUserInfo() {
        Task {
            let input = UserInfoViewModel.Input(userInfoTrigger: userInfoTrigger.asObserver())
            let output = await userInfoViewModel.transform(input: input)
            
            output.userInfo.bind { [weak self] user in
                self?.userInfoNickNameLabel.text = user.nikName
                self?.userInfoEmailLabel.text = user.email
            }.disposed(by: disposeBag)
        }
    }
}

// MARK: - alert action
extension SettingViewController {
    private func deleteMemoAlertAction() {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃하시겠습니까?", preferredStyle: .alert)
        let action = UIAlertAction(title: "로그아웃", style: .default) { [weak self] _ in
            self?.signOutAction()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - setupUI
extension SettingViewController {
    private func setupUI() {
        self.view.backgroundColor = .customSecondarySystemBackground
        
        self.view.addSubview(userInfoStackView)
        
        userInfoStackView.addSubview(userInfoView)
        userInfoView.addSubview(userInfoNickNameLabel)
        userInfoView.addSubview(userInfoEmailLabel)
        
        userInfoStackView.addSubview(editUserInfoButton)
        
        userInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            
        }
        userInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        userInfoNickNameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        userInfoEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(userInfoNickNameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
        editUserInfoButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(userInfoStackView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        if loginViewModel.firebaseAuth.currentUser != nil {
            self.view.addSubview(signOutButton)
            
            signOutButton.snp.makeConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-12)
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
                make.height.equalTo(44)
            }
        }
    }
}

// MARK: - tableView Delegate, DataSource
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingItemTableViewCell.id, for: indexPath) as? SettingItemTableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = settingItemList[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        let webViewController = WebViewController()
        
        switch settingItemList[indexPath.row] {
        case SettingItemConstant.serviceUsageGuide.rawValue:
            webViewController.url = URL(string: SettingItemConstant.serviceUsageGuide.url)
        case SettingItemConstant.privacyPolicy.rawValue:
            webViewController.url = URL(string: SettingItemConstant.privacyPolicy.url)
        default:
            return
        }
        
        self.present(webViewController, animated: true)
    }
}
