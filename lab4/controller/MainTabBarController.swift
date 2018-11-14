//
//  ViewController.swift
//  lab4
//
//  Created by Brad Hodkinson on 10/16/18.
//  Copyright © 2018 Brad Hodkinson. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tabBar.barTintColor = UIColor.black
        setupTabBar()
    }
    
    func setupTabBar() {
        
        let movieSearchViewController = UINavigationController(rootViewController: MovieSearchViewController())
        movieSearchViewController.tabBarItem.image = UIImage(named: "movie")
        movieSearchViewController.title = "Movies"
        movieSearchViewController.navigationBar.barTintColor = UIColor.black
        
        
        let favoritesViewController = UINavigationController(rootViewController: FavoritesViewController())
        favoritesViewController.tabBarItem.image = UIImage(named: "star")
        favoritesViewController.title = "Favorites"
        favoritesViewController.navigationBar.barTintColor = UIColor.black
        
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        viewControllers = [movieSearchViewController, favoritesViewController]
        
    }
    
    
}


