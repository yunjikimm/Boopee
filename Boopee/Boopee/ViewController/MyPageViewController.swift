//
//  MyPageViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit
import RxSwift

class MyPageViewController: UIViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Section, Memo>?
    
    let userMemoTrigger = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    let userMemoListViewModel = UserMemoListViewModel()
    let loginViewModel = LoginViewModel()
    
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
    private let nilCollectionViewLabel: UILabel = {
        let label = UILabel()
        label.text = "작성한 메모가 없습니다."
        return label
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setupLayout())
        collectionView.register(UserMemoCollectionViewCell.self, forCellWithReuseIdentifier: UserMemoCollectionViewCell.id)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    private lazy var settingBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingBarButtonPressed))
        return button
    }()
    
    var items: [Memo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setupUI()
        setNavigationBarButtonItems()
        bindUserMemoListViewModel()
        setDataSource()
        setCollectionViewItemSelectedRx()
    }
}

// MARK: - auth
extension MyPageViewController {
    private func setupUI() {
        self.view.backgroundColor = .secondarySystemBackground
        
        self.view.addSubview(collectionViewBoxView)
        collectionViewBoxView.addSubview(myMemoCountLabel)
        collectionViewBoxView.addSubview(collectionView)
        collectionViewBoxView.addSubview(nilCollectionViewLabel)
        
        collectionViewBoxView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        myMemoCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(myMemoCountLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        nilCollectionViewLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

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
    // MARK: - binding, snapshot, apply datasource
    private func bindUserMemoListViewModel() {
        Task {
            guard let user = loginViewModel.firebaseAuth.currentUser?.uid else { return }
            
            let input = UserMemoListViewModel.Input(userMemoTrigger: userMemoTrigger.asObservable())
            let output = await userMemoListViewModel.transform(input: input, user: user)
            
            output.userMemoList.bind { [weak self] userMemoList in
                var snapshot = NSDiffableDataSourceSnapshot<Section, Memo>()
                self?.items = userMemoList.map { $0 }
                let section = Section.searchResult
                
                snapshot.appendSections([section])
                snapshot.appendItems(self?.items ?? [], toSection: section)
                
                self?.myMemoCountLabel.text = "내가 작성한 메모 (\(userMemoList.count))"
                
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
