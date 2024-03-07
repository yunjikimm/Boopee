//
//  TabBarController.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabs()
        setTabBarUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let heightTabBar: CGFloat = 89
        
        var tabFrame = self.tabBar.frame
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
        let home = self.createNavigationController(with: "", and: UIImage(systemName: "house"), viewController: HomeViewController())
        let search = self.createNavigationController(with: "", and: UIImage(systemName: "plus.circle"), viewController: SearchViewController())
        let mypage = self.createNavigationController(with: "", and: UIImage(systemName: "person"), viewController: MyPageViewController())
        
        self.setViewControllers([home, search, mypage], animated: true)
    }
    
    private func createNavigationController(with title: String, and image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        
        navigation.tabBarItem.title = title
        navigation.tabBarItem.image = image
        
//        navigation.viewControllers.first?.navigationItem.title = title
//        navigation.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
//        navigation.navigationBar.prefersLargeTitles = true
        
//        navigation.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "button", style: .plain, target: nil, action: nil)
        
        return navigation
    }
}
