//
//  HomeTabBarController.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabs()
        setTabBarUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var tabFrame = self.tabBar.frame
        let heightTabBar: CGFloat = tabFrame.size.height + 5
        
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
        let mypage = self.createNavigationController(title: "마이페이지", image: UIImage(systemName: "person"), viewController: MyPageViewController())
        
        self.setViewControllers([home, search, mypage], animated: true)
    }
    
    private func createNavigationController(title: String, image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        
        navigation.tabBarItem.title = title
        navigation.tabBarItem.image = image
        
        let navigationImageBarButton: UIBarButtonItem = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "Logo")
            imageView.contentMode = .scaleAspectFit
            
            imageView.snp.makeConstraints { $0.width.equalTo(24) }
            
            let button = UIBarButtonItem(customView: imageView)
            return button
        }()
        
        navigation.viewControllers.first?.navigationItem.leftBarButtonItem = navigationImageBarButton
        
        return navigation
    }
}
