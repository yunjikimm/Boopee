//
//  HomeTabBarController.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit

class HomeTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabs()
        setTabBarUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var tabFrame = self.tabBar.frame
        let heightTabBar: CGFloat = tabFrame.size.height + 8
        
        tabFrame.size.height = heightTabBar
        tabFrame.origin.y = self.view.frame.size.height - heightTabBar
        self.tabBar.frame = tabFrame
    }
    
    private func setTabBarUI() {
        self.tabBar.backgroundColor = .systemBackground
        self.tabBar.tintColor = .label
        self.tabBar.unselectedItemTintColor = .systemGray
        self.tabBar.scrollEdgeAppearance = tabBar.standardAppearance
    }
    
    private func setUpTabs() {
        let home = self.createNavigationController(title: "탐색", image: UIImage(systemName: "rectangle.grid.1x2"), viewController: HomeViewController())
        let search = self.createNavigationController(title: "작성", image: UIImage(systemName: "plus.circle"), viewController: SearchViewController())
        let mypage = self.createNavigationController(title: "마이페이지", image: UIImage(systemName: "person"), viewController: MyPageViewController())
        
        self.setViewControllers([home, search, mypage], animated: true)
    }
    
    private func createNavigationController(title: String, image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        
        navigation.tabBarItem.title = title
        navigation.tabBarItem.image = image
        
        navigation.viewControllers.first?.navigationItem.title = title
        navigation.navigationBar.prefersLargeTitles = true
        
//        navigation.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "button", style: .plain, target: nil, action: nil)
        
        return navigation
    }
}
