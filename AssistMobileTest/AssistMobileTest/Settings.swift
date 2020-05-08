//
//  Settings.swift
//  AssistPayTest
//
//  Created by Sergey Kulikov on 03.08.15.
//  Copyright (c) 2015 Assist. All rights reserved.
//

import Foundation

class Settings {
    
    static let defaults = UserDefaults.standard
    
    static var useOneClick: Bool {
        get {
        return defaults.bool(forKey: "OneClick")
        }
        
        set {
            defaults.set(newValue, forKey: "OneClick")
        }
    }
    
    static var customerId: String? {
        get {
        return defaults.string(forKey: "CustomerId")
        }
        
        set {
            defaults.setValue(newValue, forKey: "CustomerId")
        }
    }
    
    static var langauge: String? {
        get {
        return defaults.string(forKey: "Language")
        }
        
        set {
            defaults.setValue(newValue, forKey: "Language")
        }
    }
    
    static var useSignature: Bool {
        get {
        return defaults.bool(forKey: "Signature")
        }
        
        set {
            defaults.set(newValue, forKey: "Signature")
        }
    }
    
    static var host: String? {
        get {
        return defaults.string(forKey: "Host")
        }
        
        set {
            defaults.setValue(newValue, forKey: "Host")
        }
    }
    
    static var privateKey: Data? {
        get {
        return defaults.data(forKey: "PrivateKey")
        }
        
        set {
            defaults.setValue(newValue, forKey: "PrivateKey")
        }
    }
    
    static var lastname: String? {
        get {
        return defaults.string(forKey: "Lastname")
        }
        
        set {
            defaults.setValue(newValue, forKey: "Lastname")
        }
    }
    
    static var firstname: String? {
        get {
        return defaults.string(forKey: "Firstname")
        }
        
        set {
            defaults.setValue(newValue, forKey: "Firstname")
        }
    }
    
    static var middlename: String? {
        get {
        return defaults.string(forKey: "Middlename")
        }
        set {
            defaults.setValue(newValue, forKey: "Middlename")
        }
    }
    
    static var email: String? {
        get {
        return defaults.string(forKey: "Email")
        }
        set {
            defaults.setValue(newValue, forKey: "Email")
        }
    }
    
    static var mobilePhone: String? {
        get {
        return defaults.string(forKey: "MobilePhone")
        }
        set {
            defaults.setValue(newValue, forKey: "MobilePhone")
        }
    }
    
    static var address: String? {
        get {
        return defaults.string(forKey: "Address")
        }
        set {
            defaults.setValue(newValue, forKey: "Address")
        }
    }
    
    static var workPhone: String? {
        get {
        return defaults.string(forKey: "WorkPhone")
        }
        set {
            defaults.setValue(newValue, forKey: "WorkPhone")
        }
    }
    
    static var homePhone: String? {
        get {
        return defaults.string(forKey: "HomePhone")
        }
        set {
            defaults.setValue(newValue, forKey: "HomePhone")
        }
    }
    
    static var fax: String? {
        get {
        return defaults.string(forKey: "Fax")
        }
        set {
            defaults.setValue(newValue, forKey: "Fax")
        }
    }
    
    static var country: String? {
        get {
        return defaults.string(forKey: "Country")
        }
        set {
            defaults.setValue(newValue, forKey: "Country")
        }
    }
    
    static var state: String? {
        get {
        return defaults.string(forKey: "State")
        }
        set {
            defaults.setValue(newValue, forKey: "State")
        }
    }
    
    static var city: String? {
        get {
        return defaults.string(forKey: "City")
        }
        set {
            defaults.setValue(newValue, forKey: "City")
        }
    }
    
    static var zip: String? {
        get {
        return defaults.string(forKey: "Zip")
        }
        set {
            defaults.setValue(newValue, forKey: "Zip")
        }
    }
    
    static var taxpayerID: String? {
        get {
        return defaults.string(forKey: "TaxpayerID")
        }
        set {
            defaults.setValue(newValue, forKey: "TaxpayerID")
        }
    }
    
    static var customerDocID: String? {
        get {
        return defaults.string(forKey: "CustomerDocID")
        }
        set {
            defaults.setValue(newValue, forKey: "CustomerDocID")
        }
    }
    
    static var paymentAddress: String? {
        get {
        return defaults.string(forKey: "PaymentAddress")
        }
        set {
            defaults.setValue(newValue, forKey: "PaymentAddress")
        }
    }
    
    static var paymentPlace: String? {
        get {
        return defaults.string(forKey: "PaymentPlace")
        }
        set {
            defaults.setValue(newValue, forKey: "PaymentPlace")
        }
    }
    
    static var cashier: String? {
        get {
        return defaults.string(forKey: "Cashier")
        }
        set {
            defaults.setValue(newValue, forKey: "Cashier")
        }
    }
    
    static var cashierINN: String? {
        get {
        return defaults.string(forKey: "CashierINN")
        }
        set {
            defaults.setValue(newValue, forKey: "CashierINN")
        }
    }
    
    static var paymentTerminal: String? {
        get {
        return defaults.string(forKey: "PaymentTerminal")
        }
        set {
            defaults.setValue(newValue, forKey: "PaymentTerminal")
        }
    }
    
    static var transferOperatorPhone: String? {
        get {
        return defaults.string(forKey: "TransferOperatorPhone")
        }
        set {
            defaults.setValue(newValue, forKey: "TransferOperatorPhone")
        }
    }
    
    static var transferOperatorName: String? {
        get {
        return defaults.string(forKey: "TransferOperatorName")
        }
        set {
            defaults.setValue(newValue, forKey: "TransferOperatorName")
        }
    }
    
    static var transferOperatorAddress: String? {
        get {
        return defaults.string(forKey: "TransferOperatorAddress")
        }
        set {
            defaults.setValue(newValue, forKey: "TransferOperatorAddress")
        }
    }
    
    static var transferOperatorINN: String? {
        get {
        return defaults.string(forKey: "TransferOperatorINN")
        }
        set {
            defaults.setValue(newValue, forKey: "TransferOperatorINN")
        }
    }
    
    static var paymentReceiverOperatorPhone: String? {
        get {
        return defaults.string(forKey: "PaymentReceiverOperatorPhone")
        }
        set {
            defaults.setValue(newValue, forKey: "PaymentReceiverOperatorPhone")
        }
    }
    
    static var paymentAgentPhone: String? {
        get {
        return defaults.string(forKey: "PaymentAgentPhone")
        }
        set {
            defaults.setValue(newValue, forKey: "PaymentAgentPhone")
        }
    }
    
    static var paymentAgentOperation: String? {
        get {
        return defaults.string(forKey: "PaymentAgentOperation")
        }
        set {
            defaults.setValue(newValue, forKey: "PaymentAgentOperation")
        }
    }
    
    static var supplierPhone: String? {
        get {
        return defaults.string(forKey: "SupplierPhone")
        }
        set {
            defaults.setValue(newValue, forKey: "SupplierPhone")
        }
    }
    
    static var paymentAgentMode: String? {
        get {
        return defaults.string(forKey: "PaymentAgentMode")
        }
        set {
            defaults.setValue(newValue, forKey: "PaymentAgentMode")
        }
    }
    
    static var documentRequisite: String? {
        get {
        return defaults.string(forKey: "DocumentRequisite")
        }
        set {
            defaults.setValue(newValue, forKey: "DocumentRequisite")
        }
    }
    
    static var userRequisites: String? {
        get {
        return defaults.string(forKey: "UserRequisites")
        }
        set {
            defaults.setValue(newValue, forKey: "UserRequisites")
        }
    }
    
    static var companyName: String? {
        get {
        return defaults.string(forKey: "CompanyName")
        }
        set {
            defaults.setValue(newValue, forKey: "CompanyName")
        }
    }
    
    static var generateReceipt: String? {
        get {
        return defaults.string(forKey: "GenerateReceipt")
        }
        set {
            defaults.setValue(newValue, forKey: "GenerateReceipt")
        }
    }
    
    static var receiptLine: String? {
        get {
        return defaults.string(forKey: "ReceiptLine")
        }
        set {
            defaults.setValue(newValue, forKey: "ReceiptLine")
        }
    }
    
    static var tax: String? {
        get {
        return defaults.string(forKey: "TAX")
        }
        set {
            defaults.setValue(newValue, forKey: "TAX")
        }
    }
    
    static var fpmode: String? {
        get {
        return defaults.string(forKey: "FPMode")
        }
        set {
            defaults.setValue(newValue, forKey: "FPMode")
        }
    }
    
    static var taxationSystem: String? {
        get {
        return defaults.string(forKey: "TaxationSystem")
        }
        set {
            defaults.setValue(newValue, forKey: "TaxationSystem")
        }
    }
    
    static var prepayment: String? {
        get {
        return defaults.string(forKey: "prepayment")
        }
        set {
            defaults.setValue(newValue, forKey: "prepayment")
        }
    }
    
    static var chequeItems: String? {
        get {
        return defaults.string(forKey: "ChequeItems")
        }
        set {
            defaults.setValue(newValue, forKey: "ChequeItems")
        }
    }
}
