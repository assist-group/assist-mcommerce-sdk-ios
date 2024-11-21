//
//  ApplePayPayment.swift
//  AssistMobileTest
//
//  Created by Sergey Kulikov on 26.12.16.
//  Copyright © 2016 Assist. All rights reserved.
//
import Foundation
import PassKit

@available(iOS 10.0, *)
class ApplePayPayment: NSObject, PKPaymentAuthorizationViewControllerDelegate, RegistrationDelegate, ResultServiceDelegate {
    
    var supportedPaymentNetworks = [PKPaymentNetwork.masterCard, PKPaymentNetwork.visa]
    var payData: PayData?
    var payDelegate: AssistPayDelegate
    var locationUpdated = true
    var registrationCompleted = false
    var merchantId: String?
    var controller: UIViewController?
    
    init(delegate: AssistPayDelegate) {
        payDelegate = delegate
        
        if #available(iOS 14.5, *) {
            supportedPaymentNetworks = [PKPaymentNetwork.masterCard, PKPaymentNetwork.visa, PKPaymentNetwork.mir]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func collectDeviceData(toResult: Bool) {
        if let data = payData {
            data.deviceUniqueId = Configuration.uuid
            data.device = Configuration.model
            data.applicationName = Configuration.appName
            data.applicationVersion = Configuration.version
            data.osLanguage = Configuration.preferredLang
            
        }
    }
    
    func pay(_ controller: UIViewController, withData: PayData, withMerchantId: String) {
        payData = withData
        
        self.controller = controller
        merchantId = withMerchantId
        
        if let params = payData {
            if (params.link ?? "").isEmpty {
                checkRegistrationAndLocation(toResult: false)
            } else {
                checkRegistrationAndLocation(toResult: true)
            }
        }
    }
    
    func checkRegistrationAndLocation(toResult: Bool) {
        if let params = payData {
            collectDeviceData(toResult: toResult)
            
            if let regId = Configuration.regId {
                params.registrationId = regId
                registrationCompleted = true
                if toResult {
                    continueResult()
                } else {
                    continuePay()
                }
            } else {
                startRegistration(toResult: toResult)
            }
        }
    }
    
    func isApplePayAvailable(withMerchantId: String) -> Bool {
        merchantId = withMerchantId
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = merchantId!
        request.supportedNetworks = supportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "RU"
        request.currencyCode = "RUB"
        
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.decimalSeparator = ","
        var amount = formatter.number(from: "1.0") as! NSDecimalNumber? ?? 1.0
        
        if !(amount.doubleValue > 0.0) {
            formatter.decimalSeparator = "."
            amount = formatter.number(from: "1.0") as! NSDecimalNumber? ?? 1.0
        }
        
        if amount.doubleValue > 0.0 {
            request.paymentSummaryItems = [
                PKPaymentSummaryItem(label: "payment", amount: amount)
            ]
        } else {
            return false
        }
        
        if let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request) {
            applePayController.delegate = self
            if PKPaymentAuthorizationViewController.canMakePayments() {
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
    func continuePay() {
        if !locationUpdated || !registrationCompleted {
            return  // wait for completion registration and location updaing
        }
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = merchantId!
        request.supportedNetworks = supportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = payData?.country ?? "RU"
        request.currencyCode = payData?.orderCurrencyStr ?? "RUB"
        
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.decimalSeparator = ","
        var amount = formatter.number(from: payData?.orderAmount ?? "0.0") as! NSDecimalNumber? ?? 0.0
        
        if !(amount.doubleValue > 0.0) {
            formatter.decimalSeparator = "."
            amount = formatter.number(from: payData?.orderAmount ?? "0.0") as! NSDecimalNumber? ?? 0.0
        }
        
        if amount.doubleValue > 0.0 {
            request.paymentSummaryItems = [
                PKPaymentSummaryItem(label: payData?.orderComment ?? "payment", amount: amount)
            ]
        } else {
            payDelegate.payFinished("", status: "ERROR", message: "Amount should be greather than zero.")
            return
        }
        
        if let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request) {
            applePayController.delegate = self
            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedPaymentNetworks) {
                controller?.present(applePayController, animated: true, completion: nil)

            } else {
                let library = PKPassLibrary()
                library.openPaymentSetup()
                payDelegate.payFinished("", status: "ERROR", message: "Can not make payment through ApplePay")
            }
        }
    }
    
    func continueResult() {
        print("continue result loc = \(locationUpdated), reg = \(registrationCompleted)")
        if locationUpdated && registrationCompleted {
            getResultReal()
        }
    }
    
    func getResultReal() {
        let request = ResultRequest()
        if let data = payData {
            request.deviceId = Configuration.uuid
            request.regId = Configuration.regId
            request.orderNo = data.orderNumber
            request.merchantId = data.merchantId
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let date = data.date ?? Date()
            request.date = dateFormatter.string(from: date)
            let service = ResultService(requestData: request, payAfterResult: true, delegate: self)
            service.start()
        }
    }
    
    func startRegistration(toResult: Bool) {
        let regData = RegistrationData()
        
        regData.name = Configuration.appName
        regData.version = Configuration.version
        regData.deviceId = Configuration.uuid
        regData.merchId = payData?.merchantId
        regData.shop = "1"
        let reg = Registration(regData: regData, regDelegate: self, toResult: toResult, payAfterResult: true)
        reg.start()
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        if let data = payData {
            data.paymentToken = String(data: payment.token.paymentData, encoding: String.Encoding.utf8)
            
            let service = ApplePayService(requestData: data, delegate: payDelegate, completion: completion)
            service.start()
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func location(_ latitude: String, longitude: String, toResult: Bool, payAfterResult: Bool) {
        if !locationUpdated {
            payData!.latitude = latitude
            payData!.longitude = longitude
            locationUpdated = true
            DispatchQueue.main.async { [unowned self] in
                if toResult {
                    self.continueResult()
                } else {
                    self.continuePay()
                }
            }
        }
    }
    
    func locationError(_ text: String) {
        if !locationUpdated {
            locationUpdated = true
            DispatchQueue.main.async { [unowned self] in
                self.continuePay()
            }
        }
    }
    
    func registration(_ id: String, toResult: Bool, payAfterResult: Bool) {
        if let params = payData {
            params.registrationId = id
            Configuration.regId = id
            registrationCompleted = true
            DispatchQueue.main.async { [unowned self] in
                if toResult {
                    self.continueResult()
                } else {
                    self.continuePay()
                }
            }
        }
    }
    
    func registration(_ faultcode: String?, faultstring: String?) {
        DispatchQueue.main.async { [unowned self] in
            var errorMessage = "Error:"
            if let code = faultcode, let string = faultstring {
                errorMessage += " faultcode = \(code), faultstring = \(string)";
            } else {
                errorMessage += " unknown"
            }
            
            self.payDelegate.payFinished("", status: "Unknown", message: errorMessage)
        }
    }
    
    func result(_ bill: String, state: String, message: String?) {
        // TODO result
    }
    
    func resultFull(_ resData: PayData) {
        resData.link = payData?.link
        resData.login = payData?.login
        resData.password = payData?.password
        payData = resData
        DispatchQueue.main.async { [unowned self] in
            self.checkRegistrationAndLocation(toResult: false)
        }
    }
    
    func resultError(_ faultcode: String?, faultstring: String?) {
        // TODO resultError
    }
}
