//
//  BookTableViewController.swift
//  crypto-address-book
//
//  Created by Mario Lin on 1/20/18.
//  Copyright © 2018 Mario Lin. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addAddressSegue, let dest = segue.destination as? UINavigationController,
            let topVC = dest.topViewController as? AddAddressViewController {
            topVC.didFinishBlock = { address in
                
            }
        }
    }
}
