//
//  ViewController.swift
//  AssistPayTest
//
//  Created by Sergey Kulikov on 29.06.15.
//  Copyright (c) 2015 Assist. All rights reserved.
//

import UIKit
import AssistMobile
import PassKit

class ViewController: UIViewController, AssistPayDelegate, AssistFiscalReceiptDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var merchantId: UITextField! {
        didSet {
            merchantId.delegate = self
        }
    }
    @IBOutlet weak var orderNumber: UITextField! {
        didSet {
            orderNumber.delegate = self
        }
    }
    @IBOutlet weak var orderAmount: UITextField! {
        didSet {
            orderAmount.delegate = self
        }
    }
    @IBOutlet weak var orderComment: UITextField! {
        didSet {
            orderComment.delegate = self
        }
    }
    @IBOutlet weak var billnumber: UITextField! {
        didSet {
            billnumber.delegate = self
        }
    }
    @IBOutlet weak var orderCurrency: UITextField! {
        didSet {
            currencyPicker.dataSource = self
            currencyPicker.delegate = self
            orderCurrency.inputView = currencyPicker
        }
    }
    @IBOutlet weak var result: UILabel!
    
    @IBOutlet weak var logn: UITextField! {
        didSet {
            logn.delegate = self
            logn.text = "sale928654"
        }
    }
    
    @IBOutlet weak var password: UITextField! {
        didSet {
            password.delegate = self
            password.text = "sale928654"
        }
    }
    
    let currencyPicker = UIPickerView()
    
    var data = PayData()
    var currencyes = [Currency.RUB.rawValue, Currency.USD.rawValue, Currency.EUR.rawValue, Currency.BYR.rawValue, Currency.UAH.rawValue]
    
    var defaults: UserDefaults?
    
    var pay: AssistPay?
    var fiscalReceipt: FiscalReceipt?
    @IBOutlet weak var apButton: UIButton!
    
    @IBAction func startPay(_ sender: UIButton) {
        data = PayData()
        pay = AssistPay(delegate: self)
        data.merchantId = merchantId.text
        data.orderNumber = orderNumber.text
        data.orderAmount = orderAmount.text
        data.orderComment = orderComment.text
        data.orderCurrency = Currency(rawValue: orderCurrency.text ?? "")
        
        if Settings.useOneClick {
            data.customerId = Settings.customerId
        }
        
        if let language = Settings.langauge {
            data.language = Language(rawValue: language)
        }
        
        if Settings.useSignature {
            data.signature = calculateSignature()
        }
        
        data.lastname = Settings.lastname
        data.firstname = Settings.firstname
        data.middlename = Settings.middlename
        data.email = Settings.email
        data.mobilePhone = Settings.mobilePhone
        
        data.address = Settings.address
        data.homePhone = Settings.homePhone
        data.workPhone = Settings.workPhone
        data.fax = Settings.fax
        data.country = Settings.country
        data.state = Settings.state
        data.city = Settings.city
        data.zip = Settings.zip
        
        data.taxpayerID = Settings.taxpayerID
        data.customerDocID = Settings.customerDocID
        data.paymentAddress = Settings.paymentAddress
        data.paymentPlace = Settings.paymentPlace
        data.cashier = Settings.cashier
        data.cashierINN = Settings.cashierINN
        data.paymentTerminal = Settings.paymentTerminal
        data.transferOperatorPhone = Settings.transferOperatorPhone
        data.transferOperatorName = Settings.transferOperatorName
        data.transferOperatorAddress = Settings.transferOperatorAddress
        data.transferOperatorINN = Settings.transferOperatorINN
        data.paymentReceiverOperatorPhone = Settings.paymentReceiverOperatorPhone
        data.paymentAgentPhone = Settings.paymentAgentPhone
        data.paymentAgentOperation = Settings.paymentAgentOperation
        data.supplierPhone = Settings.supplierPhone
        data.paymentAgentMode = Settings.paymentAgentMode
        data.documentRequisite = Settings.documentRequisite
        data.userRequisites = Settings.userRequisites
        data.companyName = Settings.companyName
        data.generateReceipt = Settings.generateReceipt
        data.receiptLine = Settings.receiptLine
        data.tax = Settings.tax
        data.fpmode = Settings.fpmode
        data.taxationSystem = Settings.taxationSystem
        data.prepayment = Settings.prepayment
        
        data.chequeItems = Settings.chequeItems
        
        AssistLinks.currentHost = Settings.host ?? AssistLinks.currentHost
        
        pay!.start(self, withData: data)
    }
    
    @IBAction func getResult(_ sender: UIButton) {
        data = PayData()
        pay = AssistPay(delegate: self)
        data.merchantId = merchantId.text
        data.orderNumber = orderNumber.text
        data.orderAmount = orderAmount.text
        data.orderComment = orderComment.text
        data.orderCurrency = Currency(rawValue: orderCurrency.text ?? "")
        
        if Settings.useOneClick {
            data.customerId = Settings.customerId
        }
        
        if let language = Settings.langauge {
            data.language = Language(rawValue: language)
        }
        
        if Settings.useSignature {
            data.signature = calculateSignature()
        }
        
        data.lastname = Settings.lastname
        data.firstname = Settings.firstname
        data.middlename = Settings.middlename
        data.email = Settings.email
        data.mobilePhone = Settings.mobilePhone
        
        data.address = Settings.address
        data.homePhone = Settings.homePhone
        data.workPhone = Settings.workPhone
        data.fax = Settings.fax
        data.country = Settings.country
        data.state = Settings.state
        data.city = Settings.city
        data.zip = Settings.zip
        
        data.taxpayerID = Settings.taxpayerID
        data.customerDocID = Settings.customerDocID
        data.paymentAddress = Settings.paymentAddress
        data.paymentPlace = Settings.paymentPlace
        data.cashier = Settings.cashier
        data.cashierINN = Settings.cashierINN
        data.paymentTerminal = Settings.paymentTerminal
        data.transferOperatorPhone = Settings.transferOperatorPhone
        data.transferOperatorName = Settings.transferOperatorName
        data.transferOperatorAddress = Settings.transferOperatorAddress
        data.transferOperatorINN = Settings.transferOperatorINN
        data.paymentReceiverOperatorPhone = Settings.paymentReceiverOperatorPhone
        data.paymentAgentPhone = Settings.paymentAgentPhone
        data.paymentAgentOperation = Settings.paymentAgentOperation
        data.supplierPhone = Settings.supplierPhone
        data.paymentAgentMode = Settings.paymentAgentMode
        data.documentRequisite = Settings.documentRequisite
        data.userRequisites = Settings.userRequisites
        data.companyName = Settings.companyName
        data.generateReceipt = Settings.generateReceipt
        data.receiptLine = Settings.receiptLine
        data.tax = Settings.tax
        data.fpmode = Settings.fpmode
        data.taxationSystem = Settings.taxationSystem
        data.prepayment = Settings.prepayment
        
        data.chequeItems = Settings.chequeItems
        
        AssistLinks.currentHost = Settings.host ?? AssistLinks.currentHost
        
        pay!.getResult(data)
    }
    
    @IBAction func getFiscalReceipt(_ sender: UIButton) {
        data = PayData()
        fiscalReceipt = FiscalReceipt(delegate: self)
        data.merchantId = merchantId.text
        data.billnumber = billnumber.text //"5928654245473783.1"
        if let df = defaults {
            data.login = df.string(forKey: "user_login")!
            data.password = df.string(forKey: "user_password")!
        }
        data.login = logn.text ?? data.login
        data.password = password.text ?? data.password
        
        AssistLinks.currentHost = Settings.host ?? AssistLinks.currentHost
        
        fiscalReceipt!.getFiscalReceipt(data)
    }
    
    @available(iOS 10.0, *)
    @IBAction func payWithApplePay(_ sender: UIButton) {
        data = PayData()
        pay = AssistPay(delegate: self)
        data.merchantId = merchantId.text
        var apmid = ""
        if let df = defaults {
            data.login = df.string(forKey: "user_login")!
            data.password = df.string(forKey: "user_password")!
            apmid = df.string(forKey: "ap_merchant_id")!
        }
        
        data.login = logn.text ?? data.login
        data.password = password.text ?? data.password
        
        data.orderNumber = orderNumber.text
        data.orderComment = orderComment.text
        data.orderAmount = orderAmount.text
        data.orderCurrency = Currency(rawValue: orderCurrency.text ?? "")
        data.lastname = Settings.lastname
        data.firstname = Settings.firstname
        if (!(Settings.middlename ?? "").isEmpty) { data.middlename = Settings.middlename }
        if (!(Settings.email ?? "").isEmpty) { data.email = Settings.email }
        if (!(Settings.mobilePhone ?? "").isEmpty) { data.mobilePhone = Settings.mobilePhone }
        
        if (!(Settings.address ?? "").isEmpty) { data.address = Settings.address }
        if (!(Settings.homePhone ?? "").isEmpty) { data.homePhone = Settings.homePhone }
        if (!(Settings.workPhone ?? "").isEmpty) { data.workPhone = Settings.workPhone }
        if (!(Settings.state ?? "").isEmpty) { data.state = Settings.state }
        if (!(Settings.city ?? "").isEmpty) { data.city = Settings.city }
        if (!(Settings.zip ?? "").isEmpty) { data.zip = Settings.zip }
        
        if (!(Settings.taxpayerID ?? "").isEmpty) { data.taxpayerID = Settings.taxpayerID }
        if (!(Settings.customerDocID ?? "").isEmpty) { data.customerDocID = Settings.customerDocID }
        if (!(Settings.paymentAddress ?? "").isEmpty) { data.paymentAddress = Settings.paymentAddress }
        if (!(Settings.paymentPlace ?? "").isEmpty) { data.paymentPlace = Settings.paymentPlace }
        if (!(Settings.cashier ?? "").isEmpty) { data.cashier = Settings.cashier }
        if (!(Settings.cashierINN ?? "").isEmpty) { data.cashierINN = Settings.cashierINN }
        if (!(Settings.paymentTerminal ?? "").isEmpty) { data.paymentTerminal = Settings.paymentTerminal }
        if (!(Settings.transferOperatorPhone ?? "").isEmpty) { data.transferOperatorPhone = Settings.transferOperatorPhone }
        if (!(Settings.transferOperatorName ?? "").isEmpty) { data.transferOperatorName = Settings.transferOperatorName }
        if (!(Settings.transferOperatorAddress ?? "").isEmpty) { data.transferOperatorAddress = Settings.transferOperatorAddress }
        if (!(Settings.transferOperatorINN ?? "").isEmpty) { data.transferOperatorINN = Settings.transferOperatorINN }
        if (!(Settings.paymentReceiverOperatorPhone ?? "").isEmpty) { data.paymentReceiverOperatorPhone = Settings.paymentReceiverOperatorPhone }
        if (!(Settings.paymentAgentPhone ?? "").isEmpty) { data.paymentAgentPhone = Settings.paymentAgentPhone }
        if (!(Settings.paymentAgentOperation ?? "").isEmpty) { data.paymentAgentOperation = Settings.paymentAgentOperation }
        if (!(Settings.supplierPhone ?? "").isEmpty) { data.supplierPhone = Settings.supplierPhone }
        if (!(Settings.paymentAgentMode ?? "").isEmpty) { data.paymentAgentMode = Settings.paymentAgentMode }
        if (!(Settings.documentRequisite ?? "").isEmpty) { data.documentRequisite = Settings.documentRequisite }
        if (!(Settings.userRequisites ?? "").isEmpty) { data.userRequisites = Settings.userRequisites }
        if (!(Settings.companyName ?? "").isEmpty) { data.companyName = Settings.companyName }
        if (!(Settings.generateReceipt ?? "").isEmpty) { data.generateReceipt = Settings.generateReceipt }
        if (!(Settings.receiptLine ?? "").isEmpty) { data.receiptLine = Settings.receiptLine }
        if (!(Settings.tax ?? "").isEmpty) { data.tax = Settings.tax }
        if (!(Settings.fpmode ?? "").isEmpty) { data.fpmode = Settings.fpmode }
        if (!(Settings.taxationSystem ?? "").isEmpty) { data.taxationSystem = Settings.taxationSystem }
        
        if (!(Settings.chequeItems ?? "").isEmpty) { data.chequeItems = Settings.chequeItems }
        
        AssistLinks.currentHost = Settings.host ?? AssistLinks.currentHost
        
        pay!.startWithApplePay(self, withData: data, applePayMerchantId: apmid)
    }
    
    override func viewDidLoad() {
        merchantId.text = "928654"
        registerSettingsBundle()
        updateDefaults()
        updateApplePayStatus()
        super.viewDidLoad()
    }
    
    func payFinished(_ bill: String, status: String, message: String?) {
        let msg = message ?? ""
        result.text = "Finished: bill = \(bill), status = \(status), message = \(msg)"
        billnumber.text = "\(bill).1"
    }
    
    func fiscalReceiptFinished(_ url: String) {
        result.text = "url: \(url)"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        orderCurrency.text = currencyes[row]
        orderCurrency.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func calculateSignature() -> String? {
        if let merchantId = data.merchantId, let orderNumber = data.orderNumber, let orderAmount = data.orderAmount, let orderCurrency = data.orderCurrency {
            let signStr = "\(merchantId);\(orderNumber);\(orderAmount);\(orderCurrency.rawValue)"
            
            print("string to sign is \(signStr)")
            if let keyData = Settings.privateKey {
                print("keyData is \(keyData)")
                if let key = Signature.nsDataToPrivateSecKey(keyData) {
                    print("key is \(key)")
                    return Signature.calc(signStr, key: key)
                }
            }
        }
        return nil
    }
    
    func registerSettingsBundle(){
        let appDefaults = ["user_login": "sale928654",
                           "user_password": "sale928654",
                           "ap_merchant_id": "merchant.ru.assist.ApplePayTest"]
        UserDefaults.standard.register(defaults: appDefaults)
        UserDefaults.standard.synchronize()
    }
    
    func updateDefaults() {
        defaults = UserDefaults.standard
    }
    
    func updateApplePayStatus() {
        var apmid = ""
        if let df = defaults {
            apmid = df.string(forKey: "ap_merchant_id")!
        }
        
        pay = AssistPay(delegate: self)
        let ap = pay!.isApplePayAvailable(applePayMerchantId: apmid)
        apButton.isEnabled = ap
    }
    
}

