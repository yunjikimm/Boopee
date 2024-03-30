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
    
    private let emptyCollectionViewLabel: UILabel = {
        let label = UILabel()
        label.text = "메모가 없습니다.\n책을 검색하고 메모를 작성해보세요!"
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
        collectionView.register(HomeMemoCollectionViewCell.self, forCellWithReuseIdentifier: HomeMemoCollectionViewCell.id)
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
        self.view.backgroundColor = .systemBackground
    }
    
    private func setupCollectionViewUI() {
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupEmptyCollectionViewUI() {
        self.view.addSubview(emptyCollectionViewLabel)
        self.view.addSubview(moveToSearchViewButton)
        
        emptyCollectionViewLabel.snp.makeConstraints { make in
            make.center.equalTo(self.view.safeAreaLayoutGuide)
        }
        moveToSearchViewButton.snp.makeConstraints { make in
            make.top.equalTo(emptyCollectionViewLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - layout
    private func setupLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] _, _ in
            self?.createSearchLayoutSection()
        }
    }
    
    private func createSearchLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}
