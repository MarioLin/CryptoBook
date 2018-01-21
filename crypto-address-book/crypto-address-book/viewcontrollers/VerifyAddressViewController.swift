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
    private lazy var colorProfile = { ColorProfile.colorProfile(type: coin) }()
    private var coin: CoinType = .btc {
        didSet {
            colorProfile = ColorProfile.colorProfile(type: coin)
        }
    }
    
    // MARK: IBActions
    @IBAction func qrButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: mainToQrSegue, sender: self)
    }
    
    @IBAction func validateAddressTapped(_ sender: Any) {
        if self.addressTextView.text.isEmpty {
            return
        }
        self.startAddressFetch(coin: self.coin, address: self.addressTextView.text.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    @IBAction func addAddressTapped(_ sender: Any) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSubviews()
        updateToCoinType()
        setupColorsToColorProfile()
    }
    
    private func setupSubviews() {
        addressTextView.placeholder = "Enter wallet address or tap the QR button to scan code"
        addressTextView.layer.borderColor = addressTextView.textColor?.cgColor;
        addressTextView.layer.borderWidth = 1.0;
        addressTextView.layer.cornerRadius = 5.0;
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedDropdown))
        labelDropdownStackView.addGestureRecognizer(tapRecognizer)
    }
    
    private func updateToCoinType() {
        coinLabel.text = CoinType.coinTypeToString(coin)
        coinLogoView.image = CoinType.coinTypeToImage(coin)
    }

    private func setupColorsToColorProfile() {
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
    
    @objc private func tappedDropdown() {
        let alertController = UIAlertController(title: "Choose coin", message: nil, preferredStyle: .actionSheet)
        
        let coinActionTapped = { (coin: CoinType) in
            if coin == self.coin {
                return
            }
            self.coin = coin
            self.updateToCoinType()
            self.setupColorsToColorProfile()
        }
        
        let btcAction = UIAlertAction(title: "BTC", style: .default) { action in
            coinActionTapped(.btc)
        }
        
        let ethAction = UIAlertAction(title: "ETH", style: .default) { action in
            coinActionTapped(.eth)
        }
        
        let ltcAction = UIAlertAction(title: "LTC", style: .default) { action in
            coinActionTapped(.ltc)
        }

        let dogeAction = UIAlertAction(title: "DOGE", style: .default) { action in
            coinActionTapped(.doge)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(btcAction)
        alertController.addAction(ethAction)
        alertController.addAction(ltcAction)
        alertController.addAction(dogeAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Network
    private func startAddressFetch(coin: CoinType, address: String) {
        let apiTransaction: ApiTransaction
        switch coin {
        case .eth:
            apiTransaction = blockCypherTransaction(coin: coin, address: address)
        case .btc, .doge, .ltc:
            apiTransaction = soChainTransaction(coin: coin, address: address)
        }
        apiTransaction.makeNetworkRequest()
    }
    
    private func blockCypherTransaction(coin: CoinType, address: String) -> BlockCypherTransaction {
        let apiTransaction = BlockCypherTransaction(coin: coin, address: address)
        apiTransaction.completion = { objects, response, error in
            
        }
        return apiTransaction
    }
    
    private func soChainTransaction(coin: CoinType, address: String) -> SoChainTransaction {
        let apiTransaction = SoChainTransaction(coin: coin, address: address)
        apiTransaction.completion = { objects, response, error in
            
        }
        return apiTransaction
    }
    
    // MARK: Nav
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == mainToQrSegue, let dest = segue.destination as? QRScannerViewController {
            dest.delegate = self
        }
    }
}

extension VerifyAddressViewController: QRScannerDelegate {
    func didCaptureQRCode(_ qrCode: String) {
        addressTextView.text = qrCode
    }
}
