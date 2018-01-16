//
//  CustomTabBarController.swift
//  FacebookNewsFeed
//
//  Created by MacBookPro on 1/16/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: feedController)
        navigationController.title = "News Feed"
        navigationController.tabBarItem.image = UIImage(named: "tab_newsfeed")
        
        let friendRequestController = OtherControllers()
        let secondNavigationController = UINavigationController(rootViewController: friendRequestController)
        secondNavigationController.title = "Request"
        secondNavigationController.tabBarItem.image = UIImage(named: "tab_request")
        
        viewControllers = [navigationController, secondNavigationController]
        
        tabBar.isTranslucent = false
        
        let topBar = CALayer()
        topBar.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.4)
        topBar.backgroundColor = UIColor.rgb(red: 229, greeen: 231, blue: 235).cgColor

        
        tabBar.layer.addSublayer(topBar)
        tabBar.clipsToBounds = true
    }
}
