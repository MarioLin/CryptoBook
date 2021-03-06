//
//  VerifyAddressViewController.swift
//  crypto-address-book
//
//  Created by Mario Lin on 1/20/18.
//  Copyright © 2018 Mario Lin. All rights reserved.
//

import UIKit
import UITextView_Placeholder

func isIphone5() -> Bool {
    return UIScreen.main.bounds.height <= 568
}

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
    @IBOutlet weak var addressValidityLabel: UILabel!
    // MARK: Non-IB Properties
    private lazy var colorProfile = { ColorProfile.colorProfile(type: coin) }()
    private var coin: CoinType = .btc {
        didSet {
            colorProfile = ColorProfile.colorProfile(type: coin)
        }
    }
    private var walletValid: Bool = false
    private var currentTransaction: ApiTransaction?
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    
    // MARK: IBActions
    @IBAction func qrButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: mainToQrSegue, sender: self)
    }
    
    @IBAction func validateAddressTapped(_ sender: Any) {
        addressTextView.resignFirstResponder()
        if addressTextView.text.isEmpty {
            return
        }
        
        if !UserDefaultsManager.shared().isValidTimeStamp() {
            presentWaitAlert()
        } else {
            UserDefaultsManager.shared().setLastSeenValidTimeStamp()
            startAddressFetch(coin: coin, address: addressTextView.text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    
    @IBAction func addAddressTapped(_ sender: Any) {
        if self.walletValid {
            performSegue(withIdentifier: mainToAddSegue, sender: self)
        } else {
            let alertController = UIAlertController(title: "Wallet is invalid.", message: "Do you still want to add this address to your address book?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default) { [unowned self] action in
                self.performSegue(withIdentifier: mainToAddSegue, sender: self)
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSubviews()
        updateToCoinType()
        setupColorsToColorProfile()
        
        setConfirmedViewsVisible(false)
    }
    
    private func setupSubviews() {
        addressTextView.placeholder = "Enter wallet address or tap the QR button to scan code"
        addressTextView.layer.borderColor = addressTextView.textColor?.cgColor;
        addressTextView.layer.borderWidth = 1.0;
        addressTextView.layer.cornerRadius = 5.0;
        addressTextView.returnKeyType = .done
        addressTextView.delegate = self
        addressTextView.autocapitalizationType = .none
        addressTextView.autocorrectionType = .no
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedDropdown))
        labelDropdownStackView.addGestureRecognizer(tapRecognizer)
        
        validateButton.isEnabled = false
        validateButton.alpha = 0.4
        
        if isIphone5() { // this is an iPhone 5+
            coinLabel.font = UIFont(name: ".SFUIDisplay-Semibold", size: 20)
            addressTextView.font = UIFont(name: ".SFUIText", size: 16)
            validateButton.titleLabel?.font = UIFont(name: ".SFUIText", size: 16)
            confirmBalance.font = UIFont(name: ".SFUIText", size: 14)
            addressValidityLabel.font = UIFont(name: ".SFUIText", size: 14)
            logoWidthConstraint.constant = 130
            logoHeightConstraint.constant = 130
        }
    }
    
    private func updateToCoinType() {
        coinLabel.text = CoinType.coinTypeToString(coin)
        coinLogoView.image = CoinType.coinTypeToImage(coin)
        
        setConfirmedViewsVisible(false)
        addressTextView.text = ""
    }

    private func setupColorsToColorProfile() {
        view.backgroundColor = colorProfile.backgroundColor
        coinLabel.textColor = colorProfile.textColor
        
        if isIphone5() {
            coinDropdown.image = #imageLiteral(resourceName: "small-dropdown").imageWithColor(color: colorProfile.textColor)
        } else {
            coinDropdown.image = #imageLiteral(resourceName: "dropdown").imageWithColor(color: colorProfile.textColor)
        }
        
        addressTextView.placeholderColor = colorProfile.placeholderColor
        addressTextView.textColor = colorProfile.textColor
        addressTextView.backgroundColor = colorProfile.placeholderBackgroundColor
        
        qrScanButton.setImage(#imageLiteral(resourceName: "qr-big").imageWithColor(color: colorProfile.textColor), for: .normal)
        
        validateButton.backgroundColor = colorProfile.buttonColor
        validateButton.setTitleColor(colorProfile.buttonTextColor, for: .normal)
        
        confirmBalance.textColor = colorProfile.textColor
        addAddressButton.setImage(#imageLiteral(resourceName: "add-button").imageWithColor(color: colorProfile.textColor), for: .normal)

        if let tabVC = tabBarController {
            tabVC.tabBar.tintColor = .bitcoinOrange
            tabVC.tabBar.barTintColor = .darkGray
        }

    }
    
    private func setConfirmedViewsVisible(_ visible: Bool) {
        confirmBalance.isHidden = !visible
        addAddressButton.isHidden = !visible
        addressValidityLabel.isHidden = !visible
    }
    
    @objc private func tappedDropdown() {
        let alertController = UIAlertController(title: "Choose coin", message: nil, preferredStyle: .actionSheet)
        
        let coinActionTapped = { (coin: CoinType) in
            if coin == self.coin {
                return
            }
            self.currentTransaction?.canceled = true
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

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(btcAction)
        alertController.addAction(ethAction)
        alertController.addAction(ltcAction)
        alertController.addAction(dogeAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    private func presentWaitAlert() {
        let alertController = UIAlertController(title: "Too many validations", message: "We received too many requests in a short period, please try again in 5-10 seconds.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Network
    private func startAddressFetch(coin: CoinType, address: String) {
        let apiTransaction: ApiTransaction
        switch coin {
        case .eth:
            apiTransaction = blockChainTranscation(isBlockCypher: true, coin: coin, address: address)
        case .btc, .doge, .ltc, .other:
            apiTransaction = blockChainTranscation(isBlockCypher: false, coin: coin, address: address)
        }
        currentTransaction = apiTransaction
        apiTransaction.makeNetworkRequest()
    }
    
    private func blockChainTranscation(isBlockCypher: Bool, coin: CoinType, address: String) -> ApiTransaction {
        let apiTransaction: ApiTransaction
        if isBlockCypher {
            apiTransaction = BlockCypherTransaction(coin: coin, address: address)
        } else {
            apiTransaction = SoChainTransaction(coin: coin, address: address)
        }
        
        self.setConfirmedViewsVisible(false)
        
        self.confirmBalance.text = "Verifying..."
        self.confirmBalance.isHidden = false

        apiTransaction.completion = { [unowned self] t, objects, response, error in
            guard t.canceled == false else { return }
            guard let t = t as? BlockChainTransaction else { return }
            if let balance = t.balance, error == nil {
                self.confirmBalance.text = "Balance: \(balance.roundToDecimal(10)) \(CoinType.coinTypeToString(self.coin))"
                self.addressValidityLabel.text = "Address is valid."
                self.addressValidityLabel.textColor = .greenLight
                self.walletValid = true
            } else if error == nil {
                self.confirmBalance.text = "Balance: N/A"
                self.addressValidityLabel.text = "Address is invalid or doesn't exist. Check the address and try again."
                self.addressValidityLabel.textColor = self.coin == .btc ? .red : .redLight
                self.walletValid = false
            } else { // error != nil
                self.confirmBalance.text = "Balance: N/A"
                self.addressValidityLabel.text = "Looks like there's a network issue, try again later."
                self.addressValidityLabel.textColor = self.coin == .btc ? .red : .redLight
                self.walletValid = false
            }
            
            self.setConfirmedViewsVisible(true)
        }
        return apiTransaction
    }
    
    // MARK: Nav
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == mainToQrSegue, let dest = segue.destination as? QRScannerViewController {
            dest.delegate = self
        }
        if segue.identifier == mainToAddSegue, let dest = segue.destination as? UINavigationController,
            let topVC = dest.topViewController as? AddAddressViewController {
            topVC.initialAddressText = addressTextView.text
            topVC.didFinishBlock = { address in
                
            }
        }
    }
}

extension VerifyAddressViewController: QRScannerDelegate {
    func didCaptureQRCode(_ qrCode: String) {
        addressTextView.text = qrCode
        validateButton.isEnabled = addressTextView.hasText
    }
}

extension VerifyAddressViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        validateButton.isEnabled = textView.hasText
        validateButton.alpha = validateButton.isEnabled ? 1 : 0.4
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { textView.resignFirstResponder() }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 50
    }

}
