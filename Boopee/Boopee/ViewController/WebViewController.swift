//
//  WebViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/28/24.
//

import UIKit
import WebKit

final class WebViewController: UIViewController, UIWebViewDelegate {
    private let webView = WKWebView()
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = webView
        
        guard let url = url else { return }
        let requset = URLRequest(url: url)
        webView.load(requset)
    }
}
