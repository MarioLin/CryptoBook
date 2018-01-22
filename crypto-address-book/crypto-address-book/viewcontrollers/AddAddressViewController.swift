//
//  AddAddressViewController.swift
//  crypto-address-book
//
//  Created by Mario Lin on 1/20/18.
//  Copyright © 2018 Mario Lin. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class AddAddressViewController: UIViewController {
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var addressTextField: UITextView!
    var initialAddressText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.placeholder = "enter wallet address or tap QR button to scan code"
        addressTextField.text = initialAddressText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
