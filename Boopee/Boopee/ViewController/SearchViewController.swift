//
//  SearchViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit
import RxSwift
import SnapKit

final class SearchViewController: UIViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Section, Book>?
    
    private let bookTrigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let bookApiviewModel = BookAPIViewModel()
    private let loginViewModel = LoginViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setupLayout())
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.id)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var items: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupUI()
        setCollectionViewItemSelectedRx()
        bindCollectionViewCellScrollPaging()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - collectionview cell selected event
extension SearchViewController {
    // MARK: - selected collectionview item
    private func setCollectionViewItemSelectedRx() {
        collectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                if self?.loginViewModel.firebaseAuth.currentUser != nil {
                    let editMemoViewController = EditMemoViewController()
                    self?.navigationController?.pushViewController(editMemoViewController, animated: true)
                    guard let documentItem = self?.items[indexPath.row] else { return }
                    editMemoViewController.config(item: documentItem)
                } else {
                    let navigationController = UINavigationController(rootViewController: LoginViewController())
                    navigationController.modalPresentationStyle = .fullScreen
                    self?.present(navigationController, animated: true)
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: -  collectionview pagination
extension SearchViewController {
    private func bindCollectionViewCellScrollPaging() {
        collectionView.rx.willEndDragging.bind { [weak self] velocity, targetContentOffset in
            guard let self = self else { return }
            
            let contentHeight = collectionView.contentSize.height
            let offsetY = collectionView.contentOffset.y
            let collectionViewHeight = collectionView.bounds.size.height
            
            if offsetY + collectionViewHeight >= contentHeight {
                self.bookTrigger.onNext(Void())
            }
        }.disposed(by: disposeBag)
    }
}

// MARK: - binding, datasource
extension SearchViewController {
    // MARK: - binding, snapshot, apply datasource
    private func bindViewModel(path: String) {
        let input = BookAPIViewModel.Input(bookTrigger: bookTrigger.asObservable())
        let output = bookApiviewModel.transform(input: input, path: path)
        
        output.bookList.bind { [weak self] bookList in
            guard let self = self else { return }
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, Book>()
            self.items.append(contentsOf: bookList.map { $0 })
            
            let section = Section.searchResult
            
            snapshot.appendSections([section])
            snapshot.appendItems(self.items, toSection: section)
            
            self.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
    }
    
    // MARK: - dataSource
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Book>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as? SearchResultCollectionViewCell
            
            cell?.configure(item: itemIdentifier)
            
            return cell
        })
    }
}

// MARK: - ui, layout
extension SearchViewController {
    // MARK: - ui
    private func setupUI() {
        self.view.backgroundColor = .customSystemBackground
        
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - layout
    private func setupLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] _, _ in
            self?.createSearchLayoutSection()
        }
    }
    
    private func createSearchLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(270))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}

// MARK: - searchController
extension SearchViewController: UISearchBarDelegate {
    // MARK: - searchController
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        
        searchController.searchBar.placeholder = "책을 검색해보세요."
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.navigationItem.searchController = searchController
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        
        self.setDataSource()
        self.bindViewModel(path: searchText)
        self.bookTrigger.onNext(Void())
    }
}

