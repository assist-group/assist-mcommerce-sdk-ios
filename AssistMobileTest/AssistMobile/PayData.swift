//
//  PayData.swift
//  AssistPayTest
//
//  Created by Sergey Kulikov on 29.06.15.
//  Copyright (c) 2015 Assist. All rights reserved.
//

import Foundation

public enum Language: String {
    case RU = "RU"
    case EN = "EN"
    case BY = "BY"
    case UK = "UK"
}

public enum Currency: String {
    case RUB = "RUB"
    case USD = "USD"
    case EUR = "EUR"
    case BYR = "BYR"
    case UAH = "UAH"
}

@objc
open class PayData: RequestData {
    
    public override init() {
        fieldValues[Fields.MobileDevice] = "6"
    }
    
    fileprivate enum Fields: String {
        case MerchantId = "Merchant_ID"
        case CustomerId = "CustomerNumber"
        case OrderNumber = "OrderNumber"
        
        case Language = "Language"
        case OrderAmount = "OrderAmount"
        case OrderComment = "OrderComment"
        case OrderCurrency = "OrderCurrency"
        case Lastname = "Lastname"
        case Firstname = "Firstname"
        case Middlename = "Middlename"
        case Email = "Email"
        case Address = "Address"
        case HomePhone = "HomePhone"
        case WorkPhone = "WorkPhone"
        case MobilePhone = "MobilePhone"
        case Fax = "Fax"
        case Country = "Country"
        case State = "State"
        case City = "City"
        case Zip = "Zip"
        case CardPayment = "CardPayment"
        case YMPayment = "YMPayment"
        case WMPayment = "WMPayment"
        case QIWIPayment = "QIWIPayment"
        case QIWIMtsPayment = "QIWIMtsPayment"
        case QIWIMegafonPayment = "QIWIMegafonPayment"
        case QIWIBeelinePayment = "QIWIBeelinePayment"
        case MobileDevice = "MobileDevice"
        case RecurringIndicator = "RecurringIndicator"
        case RecurringMinAmount = "RecurringMinAmount"
        case RecurringMaxAmount = "RecurringMaxAmount"
        case RecurringPeriod = "RecurringPeriod"
        case RecurringMaxDate = "RecurringMaxDate"
        case PaymentMode = "PaymentMode"
        case Signature = "Signature"
        case RegistrationId = "registration_id"
        case DeviceUniqueId = "DeviceUniqueID"
        case Latitude = "Latitude"
        case Longitude = "Longitude"
        case Device = "Device"
        case ApplicationName = "ApplicationName"
        case ApplicationVersion = "ApplicationVersion"
        case OsLanguage = "OsLanguage"
        case Login = "Login"
        case Password = "Password"
        case PaymentToken = "PaymentToken"
        case Billnumber = "Billnumber"
        
        case TaxpayerID = "TaxpayerID"
        case CustomerDocID = "CustomerDocID"
        case PaymentAddress = "PaymentAddress"
        case PaymentPlace = "PaymentPlace"
        case Cashier = "Cashier"
        case CashierINN = "CashierINN"
        case PaymentTerminal = "PaymentTerminal"
        case TransferOperatorPhone = "TransferOperatorPhone"
        case TransferOperatorName = "TransferOperatorName"
        case TransferOperatorAddress = "TransferOperatorAddress"
        case TransferOperatorINN = "TranferOperatorINN"
        case PaymentReceiverOperatorPhone = "PaymentReceiverOperatorPhone"
        case PaymentAgentPhone = "PaymentAgentPhone"
        case PaymentAgentOperation = "PaymentAgentOperation"
        case SupplierPhone = "SupplierPhone"
        case PaymentAgentMode = "PaymentAgentMode"
        case DocumentRequisite = "DocumentRequisite"
        case UserRequisites = "UserRequisites"
        case CompanyName = "CompanyName"
        
        case GenerateReceipt = "GenerateReceipt"
        case ReceiptLine = "ReceiptLine"
        case TAX = "TAX"
        case FPMode = "FPMode"
        case TaxationSystem = "TaxationSystem"
        case prepayment = "prepayment"
        
        case ChequeItems = "ChequeItems"
        
        case Link = "Link"
        case OutCFSID = "outcfsid"
        case ClientIP = "clientip"
    }
    
    fileprivate var fieldValues = [Fields : String]()
    
    @objc open var merchantId: String? {
        get { return fieldValues[Fields.MerchantId] }
        set { fieldValues[Fields.MerchantId] = newValue }
    }
    
    @objc open var customerId: String? {
        get { return fieldValues[Fields.CustomerId] }
        set { fieldValues[Fields.CustomerId] = newValue }
    }
    
    @objc open var orderNumber: String? {
        get { return fieldValues[Fields.OrderNumber] }
        set { fieldValues[Fields.OrderNumber] = newValue }
    }
    
    @objc open var languageStr: String? {
        get { return fieldValues[Fields.Language] }
        set { fieldValues[Fields.Language] = newValue }
    }
    
    open var language: Language? {
        get { return Language(rawValue: languageStr ?? "") }
        set { languageStr = newValue?.rawValue }
    }
    
    @objc open var orderAmount: String? {
        get { return fieldValues[Fields.OrderAmount] }
        set { fieldValues[Fields.OrderAmount] = newValue }
    }
    
    @objc open var orderComment: String? {
        get { return fieldValues[Fields.OrderComment] }
        set { fieldValues[Fields.OrderComment] = newValue }
    }
    
    @objc open var orderCurrencyStr: String? {
        get { return fieldValues[Fields.OrderCurrency] }
        set { fieldValues[Fields.OrderCurrency] = newValue }
    }
    
    open var orderCurrency: Currency? {
        get { return Currency(rawValue: orderCurrencyStr ?? "") }
        set { orderCurrencyStr = newValue?.rawValue }
    }
    
    @objc open var lastname: String? {
        get { return fieldValues[Fields.Lastname] }
        set { fieldValues[Fields.Lastname] = newValue }
    }
    
    @objc open var firstname: String? {
        get { return fieldValues[Fields.Firstname] }
        set { fieldValues[Fields.Firstname] = newValue }
    }
    
    @objc open var middlename: String? {
        get { return fieldValues[Fields.Middlename] }
        set { fieldValues[Fields.Middlename] = newValue }
    }
    
    @objc open var email: String? {
        get { return fieldValues[Fields.Email] }
        set { fieldValues[Fields.Email] = newValue }
    }
    
    @objc open var address: String? {
        get { return fieldValues[Fields.Address] }
        set { fieldValues[Fields.Address] = newValue }
    }
    
    @objc open var homePhone: String? {
        get { return fieldValues[Fields.HomePhone] }
        set { fieldValues[Fields.HomePhone] = newValue }
    }
    
    @objc open var workPhone: String? {
        get { return fieldValues[Fields.WorkPhone] }
        set { fieldValues[Fields.WorkPhone] = newValue }
    }
    
    @objc open var mobilePhone: String? {
        get { return fieldValues[Fields.MobilePhone] }
        set { fieldValues[Fields.MobilePhone] = newValue }
    }
    
    @objc open var fax: String? {
        get { return fieldValues[Fields.Fax] }
        set { fieldValues[Fields.Fax] = newValue }
    }
    
    @objc open var country: String? {
        get { return fieldValues[Fields.Country] }
        set { fieldValues[Fields.Country] = newValue }
    }
    
    @objc open var state: String? {
        get { return fieldValues[Fields.State] }
        set { fieldValues[Fields.State] = newValue }
    }
    
    @objc open var city: String? {
        get { return fieldValues[Fields.City] }
        set { fieldValues[Fields.City] = newValue }
    }
    
    @objc open var zip: String? {
        get { return fieldValues[Fields.Zip] }
        set { fieldValues[Fields.Zip] = newValue }
    }
    
    @objc open var signature: String? {
        get { return fieldValues[Fields.Signature] }
        set { fieldValues[Fields.Signature] = newValue }
    }
    
    var registrationId: String? {
        get { return fieldValues[Fields.RegistrationId] }
        set { fieldValues[Fields.RegistrationId] = newValue }
    }
    
    var deviceUniqueId: String? {
        get { return fieldValues[Fields.DeviceUniqueId] }
        set { fieldValues[Fields.DeviceUniqueId] = newValue }
    }
    
    var latitude: String? {
        get { return fieldValues[Fields.Latitude] }
        set { fieldValues[Fields.Latitude] = newValue }
    }
    
    var longitude: String? {
        get { return fieldValues[Fields.Longitude] }
        set { fieldValues[Fields.Longitude] = newValue }
    }
    
    var device: String? {
        get { return fieldValues[Fields.Device] }
        set { fieldValues[Fields.Device] = newValue }
    }
    
    var applicationName: String? {
        get { return fieldValues[Fields.ApplicationName] }
        set { fieldValues[Fields.ApplicationName] = newValue }
    }
    
    var applicationVersion: String? {
        get { return fieldValues[Fields.ApplicationVersion] }
        set { fieldValues[Fields.ApplicationVersion] = newValue }
    }
    
    var osLanguage: String? {
        get { return fieldValues[Fields.OsLanguage] }
        set { fieldValues[Fields.OsLanguage] = newValue }
    }
    
    @objc open var login: String? {
        get { return fieldValues[Fields.Login] }
        set { fieldValues[Fields.Login] = newValue }
    }
    
    @objc open var password: String? {
        get { return fieldValues[Fields.Password] }
        set { fieldValues[Fields.Password] = newValue }
    }
    
    var paymentToken: String? {
        get { return fieldValues[Fields.PaymentToken] }
        set { fieldValues[Fields.PaymentToken] = newValue }
    }
    
    @objc open var billnumber: String? {
        get { return fieldValues[Fields.Billnumber] }
        set { fieldValues[Fields.Billnumber] = newValue }
    }
    
    @objc open var date: Date?
    
    @objc open var taxpayerID: String? {
        get { return fieldValues[Fields.TaxpayerID] }
        set { fieldValues[Fields.TaxpayerID] = newValue }
    }
    
    @objc open var customerDocID: String? {
        get { return fieldValues[Fields.CustomerDocID] }
        set { fieldValues[Fields.CustomerDocID] = newValue }
    }
    
    @objc open var paymentAddress: String? {
        get { return fieldValues[Fields.PaymentAddress] }
        set { fieldValues[Fields.PaymentAddress] = newValue }
    }
    
    @objc open var paymentPlace: String? {
        get { return fieldValues[Fields.PaymentPlace] }
        set { fieldValues[Fields.PaymentPlace] = newValue }
    }
    
    @objc open var cashier: String? {
        get { return fieldValues[Fields.Cashier] }
        set { fieldValues[Fields.Cashier] = newValue }
    }
    
    @objc open var cashierINN: String? {
        get { return fieldValues[Fields.CashierINN] }
        set { fieldValues[Fields.CashierINN] = newValue }
    }
    
    @objc open var paymentTerminal: String? {
        get { return fieldValues[Fields.PaymentTerminal] }
        set { fieldValues[Fields.PaymentTerminal] = newValue }
    }
    
    @objc open var transferOperatorPhone: String? {
        get { return fieldValues[Fields.TransferOperatorPhone] }
        set { fieldValues[Fields.TransferOperatorPhone] = newValue }
    }
    
    @objc open var transferOperatorName: String? {
        get { return fieldValues[Fields.TransferOperatorName] }
        set { fieldValues[Fields.TransferOperatorName] = newValue }
    }
    
    @objc open var transferOperatorAddress: String? {
        get { return fieldValues[Fields.TransferOperatorAddress] }
        set { fieldValues[Fields.TransferOperatorAddress] = newValue }
    }
    
    @objc open var transferOperatorINN: String? {
        get { return fieldValues[Fields.TransferOperatorINN] }
        set { fieldValues[Fields.TransferOperatorINN] = newValue }
    }
    
    @objc open var paymentReceiverOperatorPhone: String? {
        get { return fieldValues[Fields.PaymentReceiverOperatorPhone] }
        set { fieldValues[Fields.PaymentReceiverOperatorPhone] = newValue }
    }
    
    @objc open var paymentAgentPhone: String? {
        get { return fieldValues[Fields.PaymentAgentPhone] }
        set { fieldValues[Fields.PaymentAgentPhone] = newValue }
    }
    
    @objc open var paymentAgentOperation: String? {
        get { return fieldValues[Fields.PaymentAgentOperation] }
        set { fieldValues[Fields.PaymentAgentOperation] = newValue }
    }
    
    @objc open var supplierPhone: String? {
        get { return fieldValues[Fields.SupplierPhone] }
        set { fieldValues[Fields.SupplierPhone] = newValue }
    }
    
    @objc open var paymentAgentMode: String? {
        get { return fieldValues[Fields.PaymentAgentMode] }
        set { fieldValues[Fields.PaymentAgentMode] = newValue }
    }
    
    @objc open var documentRequisite: String? {
        get { return fieldValues[Fields.DocumentRequisite] }
        set { fieldValues[Fields.DocumentRequisite] = newValue }
    }
    
    @objc open var userRequisites: String? {
        get { return fieldValues[Fields.UserRequisites] }
        set { fieldValues[Fields.UserRequisites] = newValue }
    }
    
    @objc open var companyName: String? {
        get { return fieldValues[Fields.CompanyName] }
        set { fieldValues[Fields.CompanyName] = newValue }
    }
    
    @objc open var generateReceipt: String? {
        get { return fieldValues[Fields.GenerateReceipt] }
        set { fieldValues[Fields.GenerateReceipt] = newValue }
    }
    
    @objc open var receiptLine: String? {
        get { return fieldValues[Fields.ReceiptLine] }
        set { fieldValues[Fields.ReceiptLine] = newValue }
    }
    
    @objc open var fpmode: String? {
        get { return fieldValues[Fields.FPMode] }
        set { fieldValues[Fields.FPMode] = newValue }
    }
    
    @objc open var tax: String? {
        get { return fieldValues[Fields.TAX] }
        set { fieldValues[Fields.TAX] = newValue }
    }
    
    @objc open var taxationSystem: String? {
        get { return fieldValues[Fields.TaxationSystem] }
        set { fieldValues[Fields.TaxationSystem] = newValue }
    }
    
    @objc open var prepayment: String? {
        get { return fieldValues[Fields.prepayment] }
        set { fieldValues[Fields.prepayment] = newValue }
    }
    
    @objc open var chequeItems: String? {
        get { return fieldValues[Fields.ChequeItems] }
        set { fieldValues[Fields.ChequeItems] = newValue }
    }
    
    @objc open var link: String? {
        get { return fieldValues[Fields.Link] }
        set { fieldValues[Fields.Link] = newValue }
    }
    
    override func buildRequestString() -> String {
        var cfsid = ""
        if let url = link {
            if (!url.isEmpty) {
                cfsid = getCFSID(url: url)
                fieldValues[Fields.OutCFSID] = cfsid
                fieldValues[Fields.ClientIP] = "127.0.0.1"
            }
        }

        return fieldValues.map { (key, value) in
            if (key != Fields.Link) {
                let escapedKey = "\(key.rawValue)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
                let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
                return escapedKey + "=" + escapedValue
            }
            return ""
            }
            .joined(separator: "&")
    }
    
    func getCFSID(url: String) -> String {
        if let cfsid = url.components(separatedBy: "CFSID=")[1].components(separatedBy: "&")[0].removingPercentEncoding {
            //print("cfsid is \(cfsid)")
            //let b = cfsid ~= "[\\w+/=]+"
            //print("cfsid valid \(b)")
            if cfsid ~= "[\\w+/=]+" {
                return cfsid
            }
        }
        return ""
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension String {
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf8.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}
