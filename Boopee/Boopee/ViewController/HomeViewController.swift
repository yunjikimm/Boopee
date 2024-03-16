//
//  HomeViewController.swift
//  Boopee
//
//  Created by yunjikim on 3/3/24.
//

import UIKit
import RxSwift
import SnapKit

class HomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    let bookApiviewModel = BookAPIViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
    }

}

