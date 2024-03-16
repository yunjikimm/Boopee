//
//  AppController.swift
//  Boopee
//
//  Created by yunjikim on 3/16/24.
//

import UIKit
import Firebase
import FirebaseAuth

final class AppController {
    static let appController = AppController()
    
    private init() {
        FirebaseApp.configure()
        registerAuthStateDidChangeEvent()
    }
    
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
        }
    }
    
    func show(in window: UIWindow) {
        self.window = window
        window.backgroundColor = .systemBackground
        window.makeKeyAndVisible()

        // 로그인이 완료된 경우에는 AuthStateDidChange 이벤트를 받아서 NotificationCenter에 의하여 자동 로그인
        if  Auth.auth().currentUser == nil {
            routeToLogin()
        }
    }
    
    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkLogin), name: .AuthStateDidChange, object: nil)
    }
        
    @objc private func checkLogin() {
        if  Auth.auth().currentUser != nil {
            setHome()
        } else {
            routeToLogin()
        }
    }
    
    private func setHome() {
        let homeVC = TabBarController()
        rootViewController = UINavigationController(rootViewController: homeVC)
    }

    private func routeToLogin() {
        let signVC = SignTabBarController()
        rootViewController = UINavigationController(rootViewController: signVC)
    }
}
