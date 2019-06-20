//
//  PayController.swift
//  AssistPayTest
//
//  Created by Sergey Kulikov on 29.06.15.
//  Copyright (c) 2015 Assist. All rights reserved.
//

import UIKit

extension NSURLRequest {
    static func allowsAnyHTTPSCertificate(forHost host: String) -> Bool {
        return host == "payments.t.paysecure.ru" || host == "payments.d.paysecure.ru"
    }
}

class PayController: UIViewController, UIWebViewDelegate, RegistrationDelegate, DeviceLocationDelegate, ResultServiceDelegate {
    
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var wait: UIActivityIndicatorView!
    
    var authenticated = false
    var locationUpdated = false
    var registrationCompleted = false
    var urlConnection: NSURLConnection?
    var badRequest: URLRequest?
    var data: PayData?
    var deviceLocation: DeviceLocation?
    weak var payDelegate: AssistPayDelegate?
    var repeated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wait.startAnimating()
        
        if let params = data {
            collectDeviceData(params)
            
            if let regId = Configuration.regId {
                params.registrationId = regId
                registrationCompleted = true
                continuePay()
            } else {
                startRegistration()
            }
        }
    }
    
    func collectDeviceData(_ data: PayData) {
        data.deviceUniqueId = Configuration.uuid
        data.device = Configuration.model
        data.applicationName = Configuration.appName
        data.applicationVersion = Configuration.version
        data.osLanguage = Configuration.preferredLang
        
        deviceLocation = DeviceLocation(delegate: self)
        deviceLocation!.requestLocation()
    }
    
    func startRegistration() {
        let regData = RegistrationData()
        
        regData.name = Configuration.appName
        regData.version = Configuration.version
        regData.deviceId = Configuration.uuid
        regData.merchId = data?.merchantId
        let reg = Registration(regData: regData, regDelegate: self)
        reg.start()
    }
    
    func startPayment(_ params: PayData) {
        print("start payment")
        let request = params.buldRequest(URL(string: AssistLinks.currentHost + AssistLinks.PayPagesService)!)
        
        webView.delegate = self
        webView.loadRequest(request)
    }
    
    func continuePay() {
        print("continue payment loc = \(locationUpdated), reg = \(registrationCompleted)")
        if locationUpdated && registrationCompleted {
            startPayment(data!)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        wait.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        print("WebView delegate");
        
        if let url = request.url {
            print("URL: \(url.path)")
            
            let path = url.path
            if path.hasSuffix("result.cfm") {
                webView.stopLoading()
                getResult()
            } else if path.hasSuffix("body.cfm") {
                webView.stopLoading()
                repeated = true
                getResult()
            }
    
        }
        
        return true
    }
    
    func registration(_ id: String) {
        print("registration: get id")
        if let params = data {
            params.registrationId = id
            Configuration.regId = id
            registrationCompleted = true
            continuePay()
        }
    }
    
    func registration(_ faultcode: String?, faultstring: String?) {
        if let fc = faultcode, let fs = faultstring {
            print("registration: error faultcode=\(fc), faultstring=\(fs)")
        }
        resultError(faultcode, faultstring: faultstring)
    }
    
    func location(_ latitude: String, longitude: String) {
        print("location updated")
        if !locationUpdated {
            data!.latitude = latitude
            data!.longitude = longitude
            locationUpdated = true
            continuePay()
        }
    }
    
    func locationError(_ text: String) {
        if !locationUpdated {
            print("location error: \(text)")
            locationUpdated = true
            continuePay()
        }
    }
    
    func getResult() {
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
            let service = ResultService(requestData: request, delegate: self)
            service.start()
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
