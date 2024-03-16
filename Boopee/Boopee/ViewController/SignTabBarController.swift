//
//  SignTabBarController.swift
//  Boopee
//
//  Created by yunjikim on 3/16/24.
//

import UIKit

class SignTabBarController: UITabBarController {
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
        let home = self.createNavigationController(with: "", and: UIImage(systemName: "house"), viewController: HomeViewController())
        let search = self.createNavigationController(with: "", and: UIImage(systemName: "plus.circle"), viewController: SearchViewController())
        let mypage = self.createNavigationController(with: "", and: UIImage(systemName: "person"), viewController: SignInViewController())
        
        self.setViewControllers([home, search, mypage], animated: true)
    }
    
    private func createNavigationController(with title: String, and image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        
        navigation.tabBarItem.title = title
        navigation.tabBarItem.image = image
        
        return navigation
    }
}
