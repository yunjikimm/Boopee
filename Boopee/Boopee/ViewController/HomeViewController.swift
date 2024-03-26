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
    
    let memoTrigger = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    let bookApiviewModel = BookAPIViewModel()
    let memoListViewModel = MemoListViewModel()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setupLayout())
        collectionView.register(HomeMemoCollectionViewCell.self, forCellWithReuseIdentifier: HomeMemoCollectionViewCell.id)
        return collectionView
    }()
    
    var items: [Memo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindMemoListViewModel()
        setDataSource()
    }
}

// MARK: - binding, datasource
extension HomeViewController {
    // MARK: - binding, snapshot, apply datasource
    private func bindMemoListViewModel() {
        Task {
            let input = MemoListViewModel.Input(memoTrigger: memoTrigger.asObserver())
            let output = await memoListViewModel.transform(input: input)
            
            output.memoList.bind { [weak self] memoList in
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
        
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}
