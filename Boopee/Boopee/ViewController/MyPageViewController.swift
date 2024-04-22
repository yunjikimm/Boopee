//
//  MyPageViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit
import RxSwift

final class MyPageViewController: UIViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Section, Memo>?
    
    private let firstFetchUserMemoTrigger = BehaviorSubject<Bool>(value: true)
    private let disposeBag = DisposeBag()
    private let userMemoListViewModel = UserMemoListViewModel()
    private let loginViewModel = LoginViewModel()
    
    private let collectionViewWrapView: UIView = {
        let view = UIView()
        view.backgroundColor = .customSystemBackground
        view.layer.cornerRadius = CornerRadiusConstant.myPageCollectionView
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        return view
    }()
    private let emptyCollectionViewWrapView: UIView = {
        let view = UIView()
        view.backgroundColor = .customSystemBackground
        return view
    }()
    private let loginWrapView: UIView = {
        let view = UIView()
        view.backgroundColor = .customSystemBackground
        return view
    }()
    private let emptyCollectionViewLabel: UILabel = {
        let label = UILabel()
        label.text = EmptyItemMessageConstant.mypage.rawValue
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .emptyItemMessageLabelColor
        label.font = .emptyItemMessageFont
        return label
    }()
    private let moveToSearchViewButton: UIButton = {
        var button = UIButton(configuration: .plain())
        button.setTitle(EmptyItemMessageConstant.home.buttonText, for: .normal)
        button.tintColor = .enableButtonLabelColor
        button.backgroundColor = .pointGreen
        button.layer.cornerRadius = CornerRadiusConstant.button
        return button
    }()
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "서비스를 이용하시려면\n로그인을 해주세요!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .emptyItemMessageLabelColor
        label.font = .emptyItemMessageFont
        return label
    }()
    private let loginButton: UIButton = {
        var button = UIButton(configuration: .plain())
        button.setTitle("로그인", for: .normal)
        button.tintColor = .enableButtonLabelColor
        button.backgroundColor = .pointGreen
        button.layer.cornerRadius = CornerRadiusConstant.button
        return button
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setupLayout())
        collectionView.register(UserMemoCollectionViewCell.self, forCellWithReuseIdentifier: UserMemoCollectionViewCell.id)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .customSystemBackground
        return collectionView
    }()
    private lazy var settingBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingBarButtonPressed))
        return button
    }()
    
    private var items: [Memo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setDataSource()
        setNavigationBarButtonItems()
        moveToSearchViewButtonPressed()
        setCollectionViewItemSelectedRx()
        bindCollectionViewCellScrollPaging()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        checkLogin()
    }
}

// MARK: - check login
extension MyPageViewController {
    private func checkLogin() {
        if let user = loginViewModel.firebaseAuth.currentUser?.uid {
            self.items.removeAll()
            self.firstFetchUserMemoTrigger.onNext(true)
            self.bindUserMemoListViewModel(user: user)
        } else {
            self.setupLoginUI()
            self.loginButtonPressed()
        }
    }
}

// MARK: - setup UI
extension MyPageViewController {
    private func setupUI() {
        self.view.backgroundColor = .customSecondarySystemBackground
        
        self.view.addSubview(collectionViewWrapView)
        
        collectionViewWrapView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setupCollectionViewUI() {
        collectionViewWrapView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setupEmptyCollectionViewUI() {
        collectionViewWrapView.addSubview(emptyCollectionViewWrapView)
        emptyCollectionViewWrapView.addSubview(emptyCollectionViewLabel)
        emptyCollectionViewWrapView.addSubview(moveToSearchViewButton)
        
        emptyCollectionViewWrapView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        emptyCollectionViewLabel.snp.makeConstraints { make in
            make.center.equalTo(emptyCollectionViewWrapView)
        }
        moveToSearchViewButton.snp.makeConstraints { make in
            make.top.equalTo(emptyCollectionViewLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupLoginUI() {
        collectionViewWrapView.addSubview(loginWrapView)
        loginWrapView.addSubview(loginLabel)
        loginWrapView.addSubview(loginButton)
        
        loginWrapView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        loginLabel.snp.makeConstraints { make in
            make.center.equalTo(loginWrapView)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - navigation bar button
extension MyPageViewController {
    private func setNavigationBarButtonItems() {
        self.navigationItem.rightBarButtonItem = settingBarButton
    }
    
    @objc private func settingBarButtonPressed() {
        let settingViewController = SettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
}

// MARK: - collectionview cell selected event
extension MyPageViewController {
    // MARK: - selected collectionview item
    private func setCollectionViewItemSelectedRx() {
        collectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                let memoDetailViewController = MemoDetailViewController()
                self?.navigationController?.pushViewController(memoDetailViewController, animated: true)
                guard let item = self?.items[indexPath.row] else { return }
                memoDetailViewController.config(item: item)
            }.disposed(by: disposeBag)
    }
}

// MARK: -  collectionview pagination
extension MyPageViewController {
    private func bindCollectionViewCellScrollPaging() {
        collectionView.rx.willEndDragging.bind { [weak self] velocity, targetContentOffset in
            guard let self = self else { return }
            guard let user = loginViewModel.firebaseAuth.currentUser?.uid else { return }
            
            let contentHeight = collectionView.contentSize.height
            let offsetY = collectionView.contentOffset.y
            let collectionViewHeight = collectionView.bounds.size.height
            
            if offsetY + collectionViewHeight >= contentHeight {
                self.firstFetchUserMemoTrigger.onNext(false)
                self.bindUserMemoListViewModel(user: user)
            }
        }.disposed(by: disposeBag)
    }
}

// MARK: - binding, datasource
extension MyPageViewController {
    // MARK: -  button binding
    private func moveToSearchViewButtonPressed() {
        moveToSearchViewButton.rx.tap.bind { [weak self] _ in
            self?.tabBarController?.selectedIndex = 1
        }.disposed(by: disposeBag)
    }
    
    private func loginButtonPressed() {
        loginButton.rx.tap.bind { [weak self] _ in
            let navigationController = UINavigationController(rootViewController: LoginViewController())
            navigationController.modalPresentationStyle = .fullScreen
            self?.present(navigationController, animated: true)
        }.disposed(by: disposeBag)
    }
    
    // MARK: - binding, snapshot, apply datasource
    private func bindUserMemoListViewModel(user: String) {
        Task {
            let input = UserMemoListViewModel.Input(firstFetchUserMemoTrigger: firstFetchUserMemoTrigger.asObserver())
            let output = await userMemoListViewModel.transform(input: input, user: user)
            
            output.userMemoList.bind { [weak self] userMemoList in
                guard let self = self else { return }
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, Memo>()
                
                self.items.append(contentsOf: userMemoList.map { $0 })
                
                if self.items.isEmpty {
                    self.setupEmptyCollectionViewUI()
                } else {
                    self.setupCollectionViewUI()
                }
                
                let section = Section.searchResult
                
                snapshot.appendSections([section])
                snapshot.appendItems(self.items, toSection: section)
                
                self.dataSource?.apply(snapshot)
            }.disposed(by: disposeBag)
        }
    }
    
    // MARK: - dataSource
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Memo>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserMemoCollectionViewCell.id, for: indexPath) as? UserMemoCollectionViewCell
            
            cell?.configure(item: itemIdentifier)
            
            return cell
        })
    }
}

// MARK: - my memo list layout
extension MyPageViewController {
    private func setupLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] _, _ in
            self?.createSearchLayoutSection()
        }
    }
    
    private func createSearchLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(145))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        section.interGroupSpacing = 20
        
        return section
    }
}
