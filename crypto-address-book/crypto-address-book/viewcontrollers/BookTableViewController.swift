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

        self.tableView.backgroundColor = .darkGray
        self.navigationController?.navigationBar.tintColor = .bitcoinOrange
        self.navigationController?.navigationBar.barTintColor = .darkGray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.litecoinSilver]
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
