//
//  FiscalReceiptService.swift
//  AssistMobile
//
//  Created by Timofey on 24/03/2020.
//  Copyright © 2020 Assist. All rights reserved.
//

import Foundation

class FiscalReceiptRequest: SoapRequest {
    struct Names {
        static let Login = "login"
        static let Password = "password"
        static let Billnumber = "billnumber"
        static let MerchantId = "merchant_id"
    }
    
    init() {
        super.init(soapAction: "http://www.paysecure.ru/ws/fiscalreceipt")
    }
    
    var login: String? {
        get {
            return data[Names.Login]
        }
        set {
            data[Names.Login] = newValue
        }
    }
    
    var password: String? {
        get {
            return data[Names.Password]
        }
        set {
            data[Names.Password] = newValue
        }
    }
    
    var billnumber: String? {
        get {
            return data[Names.Billnumber]
        }
        set {
            data[Names.Billnumber] = newValue
        }
    }
    
    var merchantId: String? {
        get {
            return data[Names.MerchantId]
        }
        set {
            data[Names.MerchantId] = newValue
        }
    }
    
    override func buildRequestHeader() -> String {
        return "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ws=\"http://www.paysecure.ru/ws/\">\n<soapenv:Header/>\n<soapenv:Body>\n<ws:fiscalreceipt>\n<format>4</format>"
    }
    
    override func buildRequestTail() -> String {
        return "</ws:fiscalreceipt>\n</soapenv:Body>\n</soapenv:Envelope>"
    }
}

protocol FiscalReceiptServiceDelegate {
    func fiscalReceiptResult(_ url: String)
    func resultError(_ faultcode: String?, faultstring: String?)
}

class FiscalReceiptService: SoapService {
    let url = ".SOAP-ENV:Envelope.SOAP-ENV:Body.ASS-NS:result.fiscalreceipt.url"
    
    fileprivate var requestData: FiscalReceiptRequest
    fileprivate var delegate: FiscalReceiptServiceDelegate
    
    init(requestData: FiscalReceiptRequest, delegate: FiscalReceiptServiceDelegate) {
        self.requestData = requestData
        self.delegate = delegate
    }
    
    func start() {
        run(requestData)
    }
    
    override func getUrl() -> String {
        return AssistLinks.currentHost + AssistLinks.FiscalReceiptService
    }
    
    override func finish(_ values: [String : String]) {
        if let url = values[url] {
            delegate.fiscalReceiptResult(url)
        } else {
            delegate.resultError(values[faultcode], faultstring: values[faultstring])
        }
    }
}
