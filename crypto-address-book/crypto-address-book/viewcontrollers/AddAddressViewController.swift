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
    
    // MARK: IBOutlets
    @IBOutlet weak var addressTextField: UITextView!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    // MARK: IBActions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func qrButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: addAddressToQrSegue, sender: self)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        let address = CryptoAddress(address: addressTextField.text,
                                    displayName: displayNameTextField.text,
                                    coinType: .btc)
        didFinishBlock?(address)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Non-IB Properties
    var initialAddressText: String?
    var didFinishBlock: ((_ address: CryptoAddress) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.placeholder = "enter wallet address or tap QR button to scan code"
        addressTextField.text = initialAddressText
        addressTextField.returnKeyType = .done
        addressTextField.textColor = .black
        addressTextField.backgroundColor = .darkGray
        addressTextField.placeholderColor = .litecoinSilver
        
        displayNameTextField.returnKeyType = .done
        displayNameTextField.attributedPlaceholder = NSAttributedString(string: "display name",
                                                                        attributes: [NSAttributedStringKey.foregroundColor: UIColor.litecoinSilver])
        addressTextField.delegate = self
        displayNameTextField.delegate = self
        
        view.backgroundColor = .darkGray

        navigationController?.navigationBar.tintColor = .bitcoinOrange
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.litecoinSilver]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addAddressToQrSegue, let dest = segue.destination as? QRScannerViewController {
            dest.delegate = self
        }
    }
}

extension AddAddressViewController: QRScannerDelegate {
    func didCaptureQRCode(_ qrCode: String) {
        addressTextField.text = qrCode
    }
}

extension AddAddressViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        navigationItem.rightBarButtonItem?.isEnabled = addressTextField.hasText && displayNameTextField.hasText
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { textView.resignFirstResponder() }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 50
    }
}

extension AddAddressViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        navigationItem.rightBarButtonItem?.isEnabled = addressTextField.hasText && displayNameTextField.hasText
        if string == "\n" { textField.resignFirstResponder() }
        let newText = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= 50
    }
}
