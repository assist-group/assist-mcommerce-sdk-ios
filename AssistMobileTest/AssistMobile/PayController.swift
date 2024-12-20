//
//  PayController.swift
//  AssistPayTest
//
//  Created by Sergey Kulikov on 29.06.15.
//  Copyright (c) 2015 Assist. All rights reserved.
//

import WebKit

extension NSURLRequest {
    static func allowsAnyHTTPSCertificate(forHost host: String) -> Bool {
        return host == "payments.t.paysecure.ru" || host == "payments.d.paysecure.ru" || host == "payments.demo.paysecure.ru"
    }
}

class PayController: UIViewController, WKNavigationDelegate, WKUIDelegate, RegistrationDelegate, ResultServiceDelegate, FiscalReceiptServiceDelegate {
    
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var wait: UIActivityIndicatorView!
    
    var authenticated = false
    var locationUpdated = true
    var registrationCompleted = false
    var urlConnection: NSURLConnection?
    var badRequest: URLRequest?
    var data: PayData?
    weak var payDelegate: AssistPayDelegate?
    weak var fiscalReceiptDelegate: AssistFiscalReceiptDelegate?
    var repeated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wait.startAnimating()
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        if let params = data {
            if (params.link ?? "").isEmpty {
                checkRegistrationAndLocation(toResult: false, payAfterResult: false)
            } else {
                checkRegistrationAndLocation(toResult: true, payAfterResult: true)
            }
        }
    }
    
    func collectDeviceData(_ data: PayData, toResult: Bool, payAfterResult: Bool) {
        data.deviceUniqueId = Configuration.uuid
        data.device = Configuration.model
        data.applicationName = Configuration.appName
        data.applicationVersion = Configuration.version
        data.osLanguage = Configuration.preferredLang
        
    }
    
    func startRegistration() {
        startRegistration(toResult: false, payAfterResult: false)
    }
    
    func startRegistration(toResult: Bool, payAfterResult: Bool) {
        let regData = RegistrationData()
        
        regData.name = Configuration.appName
        regData.version = Configuration.version
        regData.deviceId = Configuration.uuid
        regData.shop = "1"
        regData.merchId = data?.merchantId
        let reg = Registration(regData: regData, regDelegate: self, toResult: toResult, payAfterResult: payAfterResult)
        reg.start()
    }
    
    func startPayment(_ params: PayData) {
        print("start payment")
        
        var request = params.buldRequest(URL(string: AssistLinks.currentHost + AssistLinks.PayPagesService)!)
        if let link = params.link {
            if (!link.isEmpty) {
                request = params.buldRequest(URL(string: link)!)
            }
        }
        
        DispatchQueue.main.async {
            self.webView.load(request)
        }
        
    }
    
    func continuePay() {
        print("continue payment loc = \(locationUpdated), reg = \(registrationCompleted)")
        if locationUpdated && registrationCompleted {
            startPayment(data!)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish: WKNavigation!) {
        wait.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var action: WKNavigationActionPolicy?
        
        defer {
            decisionHandler(action ?? .allow)
        }
        
        print("WebView delegate")
        
        if let url = navigationAction.request.url {
            print("URL: \(url.path)")
            
            let path = url.path
            if path.hasSuffix("result.cfm") {
                action = .cancel
                getResult()
            } else if path.hasSuffix("body.cfm") {

                //action = .cancel
                //getResult()
            }
    
        }
    }
    
    func registration(_ id: String, toResult: Bool, payAfterResult: Bool) {
        print("registration: get id")
        if let params = data {
            params.registrationId = id
            Configuration.regId = id
            registrationCompleted = true
            if toResult {
                continueResult(payAfterResult: payAfterResult)
            } else {
                continuePay()
            }
        }
    }
    
    func registration(_ faultcode: String?, faultstring: String?) {
        if let fc = faultcode, let fs = faultstring {
            print("registration: error faultcode=\(fc), faultstring=\(fs)")
        }
        resultError(faultcode, faultstring: faultstring)
    }
    
    func location(_ latitude: String, longitude: String, toResult: Bool, payAfterResult: Bool) {
        print("location updated")
        if !locationUpdated {
            data!.latitude = latitude
            data!.longitude = longitude
            locationUpdated = true
            if toResult {
                continueResult(payAfterResult: payAfterResult)
            } else {
                continuePay()
            }
        }
    }
    
    func locationError(_ text: String) {
        if !locationUpdated {
            print("location error: \(text)")
            locationUpdated = true
            continuePay()
        }
    }
    
    func getFiscalReceipt() {
        let request = FiscalReceiptRequest()
        if let payData = data {
            request.login = payData.login
            request.password = payData.password
            request.billnumber = payData.billnumber
            request.merchantId = payData.merchantId
            let service = FiscalReceiptService(requestData: request, delegate: self)
            service.start()
        }
    }
    
    func fiscalReceiptResult(_ url: String) {
        let realUrl = NSURL(string: url)
        print("url: \(realUrl!)")
        DispatchQueue.main.async { [unowned self] in
            self.dismiss(animated: true, completion: nil)
            
            if let delegate = self.fiscalReceiptDelegate {
                delegate.fiscalReceiptFinished(url)
            }
        }
    }
    
    func checkRegistrationAndLocation(toResult: Bool, payAfterResult: Bool) {
        if let params = data {
            collectDeviceData(params, toResult: toResult, payAfterResult: payAfterResult)
            
            if let regId = Configuration.regId {
                params.registrationId = regId
                registrationCompleted = true
                if toResult {
                    continueResult(payAfterResult: payAfterResult)
                } else {
                    continuePay()
                }
            } else {
                startRegistration(toResult: toResult, payAfterResult: payAfterResult)
            }
        }
    }
    
    func getResult() {
        getResult(payAfterResult: false)
    }
    
    func getResult(payAfterResult: Bool) {
        checkRegistrationAndLocation(toResult: true, payAfterResult: payAfterResult)
    }
    
    func getResultReal(payAfterResult: Bool) {
        let request = ResultRequest()
        if let payData = data {
            request.deviceId = Configuration.uuid
            request.regId = Configuration.regId
            request.orderNo = payData.orderNumber
            request.merchantId = payData.merchantId
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let date = payData.date ?? Date()
            request.date = dateFormatter.string(from: date)
            let service = ResultService(requestData: request, payAfterResult: payAfterResult, delegate: self)
            service.start()
        }
    }
    
    func continueResult(payAfterResult: Bool) {
        print("continue result loc = \(locationUpdated), reg = \(registrationCompleted)")
        if locationUpdated && registrationCompleted {
            getResultReal(payAfterResult: payAfterResult)
        }
    }
    
    func result(_ bill: String, state: String, message: String?) {
        print("success: bill=\(bill), state=\(state), message=\(String(describing: message))")
        DispatchQueue.main.async { [unowned self] in
            self.dismiss(animated: true, completion: nil)
            
            if let delegate = self.payDelegate {
                var status = PaymentStatus(rawValue: state) ?? .Unknown
                if self.repeated {
                    status = .Repeated
                }
                
                delegate.payFinished(bill, status: status.rawValue, message: message)
            }
        }
    }
    
    func resultFull(_ resData: PayData) {
        resData.link = data?.link
        data = resData
        checkRegistrationAndLocation(toResult: false, payAfterResult: false)
    }
    
    func resultError(_ faultcode: String?, faultstring: String?) {
        
        DispatchQueue.main.async { [unowned self] in
            
            self.dismiss(animated: true, completion: nil)
            
            if let delegate = self.payDelegate {
                var errorMessage = "Error:"
                if let code = faultcode, let string = faultstring {
                    errorMessage += " faultcode = \(code), faultstring = \(string)";
                } else {
                    errorMessage += " unknown"
                }
                
                delegate.payFinished("", status: "Unknown", message: errorMessage)
            }
        }
    }
    
    var payData: PayData? {
        get {
            return data
        }
        set {
            data = newValue
        }
    }
    
    @IBAction func back(_ sender: UISwipeGestureRecognizer) {
        getResult()
    }
}
