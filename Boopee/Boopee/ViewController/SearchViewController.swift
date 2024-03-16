//
//  SearchViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit
import RxSwift
import SnapKit

enum Section: Hashable {
    case searchResult
}
enum Item: Hashable {
    case bookList(BookList)
}

class SearchViewController: UIViewController, UIScrollViewDelegate {
    private var dataSource: UICollectionViewDiffableDataSource<Section, BookList>?
    
    let bookTrigger = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    let bookApiviewModel = BookAPIViewModel()
    let loginViewModel = LoginViewModel.loginViewModel
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setupLayout())
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.id)
        return collectionView
    }()
    
    var items: [BookList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        setupSearchController()
        setupUI()
        
        if loginViewModel.firebaseAuth.currentUser != nil {
            setCollectionViewItemSelectedRx()
        } else {
            moveToLoginTab()
        }
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
            .subscribe { [weak self] indexPath in
                let createBookMemoViewController = CreateBookMemoViewController()
                self?.navigationController?.pushViewController(createBookMemoViewController, animated: true)
                guard let documentItem = self?.items[indexPath.row] else { return }
                createBookMemoViewController.config(item: documentItem)
            }.disposed(by: disposeBag)
    }
    
    // MARK: - nil currentUser
    private func moveToLoginTab() {
        collectionView.rx.itemSelected
            .bind { [weak self] _ in
                self?.tabBarController?.selectedIndex = 2
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
            var snapshot = NSDiffableDataSourceSnapshot<Section, BookList>()
            self?.items = bookList.map { $0 }
            let section = Section.searchResult
            
            snapshot.appendSections([section])
            snapshot.appendItems(self?.items ?? [], toSection: section)
            
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
    }
    
    // MARK: - dataSource
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, BookList>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(350))
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
        
        searchController.searchBar.placeholder = "책 검색"
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "책 검색"
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        
        self.setDataSource()
        self.bindViewModel(path: searchText)
        self.bookTrigger.onNext(Void())
    }
}

