//
//  LoginTabBarController.swift
//  Boopee
//
//  Created by yunjikim on 3/16/24.
//

import UIKit

final class LoginTabBarController: UITabBarController {
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
        self.tabBar.backgroundColor = .customSystemBackground
    }
    
    private func setUpTabs() {
        let home = self.createNavigationController(title: "탐색", image: UIImage(systemName: "rectangle.grid.1x2"), viewController: HomeViewController())
        let search = self.createNavigationController(title: "작성", image: UIImage(systemName: "plus.circle"), viewController: SearchViewController())
        let mypage = self.createNavigationController(title: "마이페이지", image: UIImage(systemName: "person"), viewController: LoginViewController())
        
        self.setViewControllers([home, search, mypage], animated: true)
    }
    
    private func createNavigationController(title: String, image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        
        navigation.tabBarItem.title = title
        navigation.tabBarItem.image = image
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "boopee"
            label.textColor = .pointGreen
            label.font = .systemFont(ofSize: 24, weight: .bold)
            return label
        }()
        
        let titleButton = UIBarButtonItem(customView: titleLabel)
        
        navigation.viewControllers.first?.navigationItem.leftBarButtonItem = titleButton
        
        return navigation
    }
}
