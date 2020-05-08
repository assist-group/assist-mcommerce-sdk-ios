//
//  CustomerExtraSettingsViewController.swift
//  AssistPayTest
//
//  Created by Sergey Kulikov on 07.08.15.
//  Copyright (c) 2015 Assist. All rights reserved.
//

import UIKit

class CustomerExtraSettingsViewController: UIViewController {
    
    @IBOutlet weak var address: UITextField! {
        didSet {
            address.text = Settings.address ?? ""
        }
    }
    
    @IBOutlet weak var homePhone: UITextField! {
        didSet {
            homePhone.text = Settings.homePhone ?? ""
        }
    }
    
    @IBOutlet weak var workPhone: UITextField! {
        didSet {
            workPhone.text = Settings.workPhone ?? ""
        }
    }
    
    @IBOutlet weak var fax: UITextField! {
        didSet {
            fax.text = Settings.fax ?? ""
        }
    }
    
    @IBOutlet weak var country: UITextField! {
        didSet {
            country.text = Settings.country ?? ""
        }
    }
    
    @IBOutlet weak var state: UITextField! {
        didSet {
            state.text = Settings.state ?? ""
        }
    }
    
    @IBOutlet weak var city: UITextField! {
        didSet {
            city.text = Settings.city ?? ""
        }
    }
    
    @IBOutlet weak var zip: UITextField! {
        didSet {
            zip.text = Settings.zip ?? ""
        }
    }
    
    @IBOutlet weak var taxpayerID: UITextField! {
        didSet {
            taxpayerID.text = Settings.taxpayerID ?? ""
        }
    }
    
    @IBOutlet weak var customerDocID: UITextField! {
        didSet {
            customerDocID.text = Settings.customerDocID ?? ""
        }
    }
    
    @IBOutlet weak var paymentAddress: UITextField! {
        didSet {
            paymentAddress.text = Settings.paymentAddress ?? ""
        }
    }
    
    @IBOutlet weak var paymentPlace: UITextField! {
        didSet {
            paymentPlace.text = Settings.paymentPlace ?? ""
        }
    }
    
    @IBOutlet weak var cashier: UITextField! {
        didSet {
            cashier.text = Settings.cashier ?? ""
        }
    }
    
    @IBOutlet weak var cashierINN: UITextField! {
        didSet {
            cashierINN.text = Settings.cashierINN ?? ""
        }
    }
    
    @IBOutlet weak var paymentTerminal: UITextField! {
        didSet {
            paymentTerminal.text = Settings.paymentTerminal ?? ""
        }
    }
    
    @IBOutlet weak var transferOperatorPhone: UITextField! {
        didSet {
            transferOperatorPhone.text = Settings.transferOperatorPhone ?? ""
        }
    }
    
    @IBOutlet weak var transferOperatorName: UITextField! {
        didSet {
            transferOperatorName.text = Settings.transferOperatorName ?? ""
        }
    }
    
    @IBOutlet weak var transferOperatorAddress: UITextField! {
        didSet {
            transferOperatorAddress.text = Settings.transferOperatorAddress ?? ""
        }
    }
    
    @IBOutlet weak var transferOperatorINN: UITextField! {
        didSet {
            transferOperatorINN.text = Settings.transferOperatorINN ?? ""
        }
    }
    
    @IBOutlet weak var paymentReceiverOperatorPhone: UITextField! {
        didSet {
            paymentReceiverOperatorPhone.text = Settings.paymentReceiverOperatorPhone ?? ""
        }
    }
    
    @IBOutlet weak var paymentAgentPhone: UITextField! {
        didSet {
            paymentAgentPhone.text = Settings.paymentAgentPhone ?? ""
        }
    }
    
    @IBOutlet weak var paymentAgentOperation: UITextField! {
        didSet {
            paymentAgentOperation.text = Settings.paymentAgentOperation ?? ""
        }
    }
    
    @IBOutlet weak var supplierPhone: UITextField! {
        didSet {
            supplierPhone.text = Settings.supplierPhone ?? ""
        }
    }
    
    @IBOutlet weak var paymentAgentMode: UITextField! {
        didSet {
            paymentAgentMode.text = Settings.paymentAgentMode ?? ""
        }
    }
    
    @IBOutlet weak var documentRequisite: UITextField! {
        didSet {
            documentRequisite.text = Settings.documentRequisite ?? ""
        }
    }
    
    @IBOutlet weak var userRequisites: UITextField! {
        didSet {
            userRequisites.text = Settings.userRequisites ?? ""
        }
    }
    
    @IBOutlet weak var companyName: UITextField! {
        didSet {
            companyName.text = Settings.companyName ?? ""
        }
    }
    
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
    
    @IBOutlet weak var prepayment: UITextField! {
        didSet {
            prepayment.text = Settings.prepayment ?? ""
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        Settings.address = address.text
        Settings.homePhone = homePhone.text
        Settings.workPhone = workPhone.text
        Settings.fax = fax.text
        Settings.country = country.text
        Settings.state = state.text
        Settings.city = city.text
        Settings.zip = zip.text
        
        Settings.taxpayerID = taxpayerID.text
        Settings.customerDocID = customerDocID.text
        Settings.paymentAddress = paymentAddress.text
        Settings.paymentPlace = paymentPlace.text
        Settings.cashier = cashier.text
        Settings.cashierINN = cashierINN.text
        Settings.paymentTerminal = paymentTerminal.text
        Settings.transferOperatorPhone = transferOperatorPhone.text
        Settings.transferOperatorName = transferOperatorName.text
        Settings.transferOperatorAddress = transferOperatorAddress.text
        Settings.transferOperatorINN = transferOperatorINN.text
        Settings.paymentReceiverOperatorPhone = paymentReceiverOperatorPhone.text
        Settings.paymentAgentPhone = paymentAgentPhone.text
        Settings.paymentAgentOperation = paymentAgentOperation.text
        Settings.supplierPhone = supplierPhone.text
        Settings.paymentAgentMode = paymentAgentMode.text
        Settings.documentRequisite = documentRequisite.text
        Settings.userRequisites = userRequisites.text
        Settings.companyName = companyName.text
        
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
