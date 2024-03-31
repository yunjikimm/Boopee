//
//  HomeViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit
import RxSwift
import SnapKit

final class HomeViewController: UIViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Section, Memo>?
    
    private let memoTrigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let bookApiviewModel = BookAPIViewModel()
    private let memoListViewModel = MemoListViewModel()
    private let loginViewModel = LoginViewModel()
    
    private let emptyCollectionViewLabel: UILabel = {
        let label = UILabel()
        label.text = EmptyItemMessageConstant.home.rawValue
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
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setupLayout())
        collectionView.register(HomeMemoCollectionViewCell.self, forCellWithReuseIdentifier: HomeMemoCollectionViewCell.id)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var items: [Memo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        moveToSearchViewButtonPressed()
        setDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindMemoListViewModel()
    }
}

// MARK: - binding, datasource
extension HomeViewController {
    // MARK: -  button binding
    private func moveToSearchViewButtonPressed() {
        moveToSearchViewButton.rx.tap.bind { [weak self] _ in
            self?.tabBarController?.selectedIndex = 1
        }.disposed(by: disposeBag)
    }
    
    // MARK: - binding, snapshot, apply datasource
    private func bindMemoListViewModel() {
        Task {
            let input = MemoListViewModel.Input(memoTrigger: memoTrigger.asObserver())
            let output = await memoListViewModel.transform(input: input)
            
            output.memoList.bind { [weak self] memoList in
                if memoList.isEmpty {
                    self?.setupEmptyCollectionViewUI()
                } else {
                    self?.setupCollectionViewUI()
                }
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, Memo>()
                self?.items = memoList.map { $0 }
                let section = Section.home
                
                snapshot.appendSections([section])
                snapshot.appendItems(self?.items ?? [], toSection: section)
                
                self?.dataSource?.apply(snapshot)
            }.disposed(by: disposeBag)
        }
    }
    
    // MARK: - dataSource
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Memo>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMemoCollectionViewCell.id, for: indexPath) as? HomeMemoCollectionViewCell
            
            cell?.configure(item: itemIdentifier)
            
            return cell
        })
    }
}

// MARK: - ui, layout
extension HomeViewController {
    // MARK: - ui
    private func setupUI() {
        self.view.backgroundColor = .customSecondarySystemBackground
    }
    
    private func setupCollectionViewUI() {
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupEmptyCollectionViewUI() {
        self.view.addSubview(emptyCollectionViewLabel)
        
        emptyCollectionViewLabel.snp.makeConstraints { make in
            make.center.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        if loginViewModel.firebaseAuth.currentUser != nil {
            self.view.addSubview(moveToSearchViewButton)
            
            moveToSearchViewButton.snp.makeConstraints { make in
                make.top.equalTo(emptyCollectionViewLabel.snp.bottom).offset(12)
                make.centerX.equalToSuperview()
            }
        }
    }
    
    // MARK: - layout
    private func setupLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] _,_ in
            self?.createSearchLayoutSection()
        }
    }
    
    private func createSearchLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        return section
    }
}
