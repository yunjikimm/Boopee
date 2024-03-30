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
    
    private let userMemoTrigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let userMemoListViewModel = UserMemoListViewModel()
    private let loginViewModel = LoginViewModel()
    
    private let collectionViewBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        return view
    }()
    private let myMemoCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "내가 작성한 메모 (0)"
        return label
    }()
    private let emptyCollectionViewLabel: UILabel = {
        let label = UILabel()
        label.text = "작성한 메모가 없습니다.\n책을 검색하고 메모를 작성해보세요!"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let moveToSearchViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("메모 작성하러 가기", for: .normal)
        button.tintColor = .systemGray
        button.configuration = .gray()
        return button
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setupLayout())
        collectionView.register(UserMemoCollectionViewCell.self, forCellWithReuseIdentifier: UserMemoCollectionViewCell.id)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    private lazy var settingBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingBarButtonPressed))
        return button
    }()
    
    private var items: [Memo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setupUI()
        setNavigationBarButtonItems()
        moveToSearchViewButtonPressed()
        setDataSource()
        setCollectionViewItemSelectedRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        bindUserMemoListViewModel()
    }
}

// MARK: - setup UI
extension MyPageViewController {
    private func setupUI() {
        self.view.backgroundColor = .secondarySystemBackground
        
        self.view.addSubview(collectionViewBoxView)
        collectionViewBoxView.addSubview(myMemoCountLabel)
        
        collectionViewBoxView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        myMemoCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    private func setupCollectionViewUI() {
        collectionViewBoxView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(myMemoCountLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupEmptyCollectionViewUI() {
        collectionViewBoxView.addSubview(emptyCollectionViewLabel)
        collectionViewBoxView.addSubview(moveToSearchViewButton)
        
        emptyCollectionViewLabel.snp.makeConstraints { make in
            make.center.equalTo(self.view.safeAreaLayoutGuide)
        }
        moveToSearchViewButton.snp.makeConstraints { make in
            make.top.equalTo(emptyCollectionViewLabel.snp.bottom).offset(12)
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
            .subscribe { [weak self] indexPath in
                let memoDetailViewController = MemoDetailViewController()
                self?.navigationController?.pushViewController(memoDetailViewController, animated: true)
                guard let item = self?.items[indexPath.row] else { return }
                memoDetailViewController.config(item: item)
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
    
    // MARK: - binding, snapshot, apply datasource
    private func bindUserMemoListViewModel() {
        Task {
            guard let user = loginViewModel.firebaseAuth.currentUser?.uid else { return }
            
            let input = UserMemoListViewModel.Input(userMemoTrigger: userMemoTrigger.asObservable())
            let output = await userMemoListViewModel.transform(input: input, user: user)
            
            output.userMemoList.bind { [weak self] userMemoList in
                if userMemoList.isEmpty {
                    self?.setupEmptyCollectionViewUI()
                } else {
                    self?.setupCollectionViewUI()
                    self?.myMemoCountLabel.text = "내가 작성한 메모 (\(userMemoList.count))"
                }
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, Memo>()
                self?.items = userMemoList.map { $0 }
                let section = Section.searchResult
                
                snapshot.appendSections([section])
                snapshot.appendItems(self?.items ?? [], toSection: section)
                
                self?.dataSource?.apply(snapshot)
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 18, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / 3.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}
