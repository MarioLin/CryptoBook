//
//  RootTabBarViewController.swift
//  crypto-address-book
//
//  Created by Mario Lin on 2/19/18.
//  Copyright © 2018 Mario Lin. All rights reserved.
//

import UIKit
import CoreData

class RootTabBarViewController: UITabBarController {

    var viewContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Passing down the view context
        viewControllers?.forEach({ vc in
            guard let navVC = vc as? UINavigationController else { return }
            for innerVC in navVC.viewControllers where innerVC is BookTableViewController {
                (innerVC as? BookTableViewController)?.viewContext = self.viewContext
            }
        })
    }
}
