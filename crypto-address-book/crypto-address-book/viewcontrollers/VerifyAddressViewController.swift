//
//  VerifyAddressViewController.swift
//  crypto-address-book
//
//  Created by Mario Lin on 1/20/18.
//  Copyright © 2018 Mario Lin. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class VerifyAddressViewController: UIViewController {

    @IBOutlet weak var addressTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addressTextView.placeholder = "Enter wallet address or tap the QR button to scan code"
        
        addressTextView.layer.borderColor = addressTextView.textColor?.cgColor;
        addressTextView.layer.borderWidth = 1.0;
        addressTextView.layer.cornerRadius = 5.0;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
