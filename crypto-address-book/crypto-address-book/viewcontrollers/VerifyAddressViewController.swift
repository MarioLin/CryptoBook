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

    // MARK: IBOutlets
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var coinDropdown: UIImageView!
    @IBOutlet weak var labelDropdownStackView: UIStackView!
    @IBOutlet weak var coinLogoView: UIImageView!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var qrScanButton: UIButton!
    @IBOutlet weak var validateButton: RoundedBurritoButton!
    @IBOutlet weak var confirmBalance: UILabel!
    @IBOutlet weak var addAddressButton: UIButton!
    
    // MARK: Non-IB Properties
    private lazy var colorProfile = { ColorProfile.colorProfile(type: .btc) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addressTextView.placeholder = "Enter wallet address or tap the QR button to scan code"
        addressTextView.layer.borderColor = addressTextView.textColor?.cgColor;
        addressTextView.layer.borderWidth = 1.0;
        addressTextView.layer.cornerRadius = 5.0;
        setupColorsToProfile()
    }

    private func setupColorsToProfile() {
        view.backgroundColor = colorProfile.backgroundColor
        coinLabel.textColor = colorProfile.textColor
        coinDropdown.image = #imageLiteral(resourceName: "dropdown").imageWithColor(color: colorProfile.textColor)
        
        addressTextView.placeholderColor = colorProfile.placeholderColor
        addressTextView.textColor = colorProfile.textColor
        addressTextView.backgroundColor = colorProfile.placeholderBackgroundColor
        
        qrScanButton.setImage(#imageLiteral(resourceName: "qr-big").imageWithColor(color: colorProfile.textColor), for: .normal)
        
        validateButton.backgroundColor = colorProfile.buttonColor
        validateButton.setTitleColor(colorProfile.buttonTextColor, for: .normal)
        
        confirmBalance.textColor = colorProfile.textColor
        addAddressButton.setImage(#imageLiteral(resourceName: "add-button").imageWithColor(color: colorProfile.textColor), for: .normal)

        if let tabVC = tabBarController {
            tabVC.tabBar.tintColor = colorProfile.textColor
            tabVC.tabBar.barTintColor = colorProfile.backgroundColor
        }
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
