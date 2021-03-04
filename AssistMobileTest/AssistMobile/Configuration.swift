//
//  Configuration.swift
//  AssistPayTest
//
//  Created by Sergey Kulikov on 01.07.15.
//  Copyright (c) 2015 Assist. All rights reserved.
//

import Foundation
import UIKit


open class AssistLinks {
    public static var currentHost = hosts[0]
    public static let hosts = ["https://payments.t.paysecure.ru", "https://payments.d.paysecure.ru", "https://payments.demo.paysecure.ru", "https://payments.paysecure.ru", "https://test.paysecure.ru", "https://test.paysec.by", "https://payments.paysec.by" ]
    
    static let RegService = "/registration/mobileregistration.cfm"
    static let PayPagesService = "/pay/order.cfm"
    static let ResultService = "/orderresult/mobileorderresult.cfm"
    static let FiscalReceiptService = "/fiscal/fiscalreceipt.cfm"
    static let ApplePayService = "/pay/tokenpay.cfm"
    static let ApplePayByOrderService = "/pay/tokenpay_order.cfm"
}

class Configuration {
    
    fileprivate static var regIdField: String {
        return "\(appName!).\(version!).AssistRegId"
    }
    
    static let defaults = UserDefaults.standard
    
    static var regId: String? {
        get {
        if let regId = defaults.string(forKey: regIdField) {
        return regId
    } else {
        return nil
        }
        }
        
        set {
            defaults.setValue(newValue, forKey: regIdField)
        }
    }
    
    static var appName: String? {
        get {
            return Bundle.main.infoDictionary!["CFBundleName"] as? String
        }
    }
    
    static var version: String? {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    }
    
    static var uuid: String? {
        get {
            if let idForVendor = UIDevice.current.identifierForVendor {
                return "IOS" + idForVendor.uuidString
            } else {
                return nil
            }
        }
    }
    
    static var model: String? {
        get {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            return identifier
        }
    }
    
    static var preferredLang: String? {
        get {
            return Locale.preferredLanguages[0]
        }
    }
    
}
