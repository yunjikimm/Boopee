//
//  SettingViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/28/24.
//

import UIKit
import RxSwift

final class SettingViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let loginViewModel = LoginViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SettingItemTableViewCell.self, forCellReuseIdentifier: SettingItemTableViewCell.id)
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderTopPadding = 0
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
    
    private lazy var settingItemList = [
        [loginViewModel.firebaseAuth.currentUser?.email ?? "계정 없음"],
        [SettingItemConstant.serviceUsageGuide.rawValue, SettingItemConstant.privacyPolicy.rawValue],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "설정"
        self.tabBarController?.tabBar.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
        bindSignOutButton()
    }
}

// MARK: - sign out button action
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
        self.view.backgroundColor = .customSystemBackground
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        if loginViewModel.firebaseAuth.currentUser != nil {
            self.view.addSubview(signOutButton)
            
            signOutButton.snp.makeConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-12)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.height.equalTo(44)
            }
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItemList[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingItemTableViewCell.id, for: indexPath)
        cell.textLabel?.text = settingItemList[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        let webViewController = WebViewController()
        
        switch settingItemList[indexPath.section][indexPath.row] {
        case SettingItemConstant.serviceUsageGuide.rawValue:
            webViewController.url = URL(string: SettingItemConstant.serviceUsageGuide.url)
        case SettingItemConstant.privacyPolicy.rawValue:
            webViewController.url = URL(string: SettingItemConstant.privacyPolicy.url)
        default:
            return
        }
        
        self.present(webViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "내 계정"
        case 1:
            return "앱 정보"
        default:
            return ""
        }
    }
}
