//
//  FiscalSettingsViewController.swift
//  AssistMobileTest
//
//  Created by Timofey on 07/05/2020.
//  Copyright © 2020 Assist. All rights reserved.
//

import UIKit

class FiscalSettingsViewController: UIViewController {
    
    @IBOutlet weak var generateReceipt: UITextField! {
        didSet {
            generateReceipt.text = Settings.generateReceipt ?? ""
        }
    }
    
    @IBOutlet weak var receiptLine: UITextField! {
        didSet {
            receiptLine.text = Settings.receiptLine ?? ""
        }
    }
    
    @IBOutlet weak var tax: UITextField! {
        didSet {
            tax.text = Settings.tax ?? ""
        }
    }
    
    @IBOutlet weak var fpmode: UITextField! {
        didSet {
            fpmode.text = Settings.fpmode ?? ""
        }
    }
    
    @IBOutlet weak var taxationSystem: UITextField! {
        didSet {
            taxationSystem.text = Settings.taxationSystem ?? ""
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        Settings.generateReceipt = generateReceipt.text
        Settings.receiptLine = receiptLine.text
        Settings.tax = tax.text
        Settings.fpmode = fpmode.text
        Settings.taxationSystem = taxationSystem.text
        
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
