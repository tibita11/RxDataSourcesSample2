//
//  AppDescriptionViewController.swift
//  RxDataSourcesSample2
//
//  Created by 鈴木楓香 on 2023/02/22.
//

import UIKit

class AppDescriptionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "About this app"
    }


}
