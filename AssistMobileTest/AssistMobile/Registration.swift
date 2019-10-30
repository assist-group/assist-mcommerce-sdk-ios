//
//  Registration.swift
//  AssistPayTest
//
//  Created by Sergey Kulikov on 02.07.15.
//  Copyright (c) 2015 Assist. All rights reserved.
//

import Foundation

class RegistrationData: SoapRequest {
    
    struct Names {
        static let ApplicationName = "ApplicationName"
        static let ApplicationVersion = "ApplicationVersion"
        static let MerchantID = "Merchant_ID"
        static let DeviceID = "DeviceUniqueId"
        static let Shop = "Shop"
    }
    
    init() {
        super.init(soapAction: "http://www.paysecure.ru/ws/getregistration")
    }
    
    var name: String? {
        get {
            return data[Names.ApplicationName]
        }
        set {
            data[Names.ApplicationName] = newValue
        }
    }
    
    var version: String? {
        get {
            return data[Names.ApplicationVersion]
        }
        set {
            data[Names.ApplicationVersion] = newValue
        }
    }
    
    var deviceId: String? {
        get {
            return data[Names.DeviceID]
        }
        set {
            data[Names.DeviceID] = newValue
        }
    }
    
    var shop: String? {
        get {
            return data[Names.Shop]
        }
        set {
            data[Names.Shop] = newValue
        }
    }
    
    var merchId: String? {
        get {
            return data[Names.MerchantID]
        }
        set {
            data[Names.MerchantID] = newValue
        }
    }
    
    override func buildRequestHeader() -> String {
        return "<s11:Envelope xmlns:s11=\"http://schemas.xmlsoap.org/soap/envelope/\">\n<s11:Body>\n<ns1:getRegistration xmlns:ns1=\"http://www.paysecure.ru/ws/\">\n"
    }
    
    override func buildRequestTail() -> String {
        return "</ns1:getRegistration>\n</s11:Body>\n</s11:Envelope>"
    }
    
}

protocol RegistrationDelegate {
    func registration(_ id: String)
    func registration(_ faultcode: String?, faultstring: String?)
}

class Registration: SoapService {
    fileprivate var registrationData: RegistrationData
    fileprivate var delegate: RegistrationDelegate
    
    let RegId = ".SOAP-ENV:Envelope.SOAP-ENV:Body.ASS-NS:getRegistrationResponse.registration_id"
    let RegId2 = ".SOAP-ENV:Envelope.SOAP-ENV:Body.tns:getRegistrationResponse.registration_id"
    
    init(regData: RegistrationData, regDelegate: RegistrationDelegate) {
        registrationData = regData
        delegate = regDelegate
    }
    
    func start() {
        run(registrationData)
    }
    
    override func getUrl() -> String {
        return AssistLinks.currentHost + AssistLinks.RegService
    }
    
    override func finish(_ values: [String:String]) {
        if let id = values[RegId] {
            delegate.registration(id)
        } else if let id = values[RegId2] {
            delegate.registration(id)
        } else {
            delegate.registration(values[faultcode], faultstring: values[faultstring])
        }
    }
}
