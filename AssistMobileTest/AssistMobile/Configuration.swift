//
//  Configuration.swift
//  AssistPayTest
//
//  Created by Sergey Kulikov on 01.07.15.
//  Copyright (c) 2015 Assist. All rights reserved.
//

import Foundation
import UIKit


@objc open class AssistLinks: NSObject {
    @objc public static var currentHost = hosts[0]
    @objc public static let hosts = ["https://payments.t.paysecure.ru", "https://payments.d.paysecure.ru", "https://payments.paysecure.ru", "https://test.paysecure.ru", "https://test.paysec.by", "https://payments.paysec.by" ]
    
    static let RegService = "/registration/mobileregistration.cfm"
    static let PayPagesService = "/pay/order.cfm"
    static let ResultService = "/orderresult/mobileorderresult.cfm"
    static let ApplePayService = "/pay/tokenpay.cfm"
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
            var sysinfo = utsname()
            uname(&sysinfo) // ignore return value
            return NSString(bytes: &sysinfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue)! as String
        }
    }
    
    static var preferredLang: String? {
        get {
            return Locale.preferredLanguages[0]
        }
    }
    
}
