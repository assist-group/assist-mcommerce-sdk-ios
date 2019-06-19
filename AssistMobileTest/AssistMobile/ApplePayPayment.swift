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
class ApplePayPayment: NSObject, PKPaymentAuthorizationViewControllerDelegate, DeviceLocationDelegate, RegistrationDelegate {
    
    let supportedPaymentNetworks = [PKPaymentNetwork.masterCard, PKPaymentNetwork.visa]
    var payData: PayData?
    var payDelegate: AssistPayDelegate
    var deviceLocation: DeviceLocation?
    var locationUpdated = false
    var registrationCompleted = false
    var merchantId: String?
    var controller: UIViewController?
    
    init(delegate: AssistPayDelegate) {
        payDelegate = delegate
    }
    
    func collectDeviceData() {
        if let data = payData {
            data.deviceUniqueId = Configuration.uuid
            data.device = Configuration.model
            data.applicationName = Configuration.appName
            data.applicationVersion = Configuration.version
            data.osLanguage = Configuration.preferredLang
            
            deviceLocation = DeviceLocation(delegate: self)
            deviceLocation!.requestLocation()
        }
    }
    
    func pay(_ controller: UIViewController, withData: PayData, withMerchantId: String) {
        payData = withData
        
        self.controller = controller
        merchantId = withMerchantId
        
        collectDeviceData()
        
        if let regId = Configuration.regId {
            payData?.registrationId = regId
            registrationCompleted = true
            continuePay()
        } else {
            startRegistration()
        }
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
                payDelegate.payFinished("", status: "ERROR", message: "Can not make payment through ApplePay")
            }
        }
    }
    
    func startRegistration() {
        let regData = RegistrationData()
        
        regData.name = Configuration.appName
        regData.version = Configuration.version
        regData.deviceId = Configuration.uuid
        regData.shop = payData?.merchantId
        let reg = Registration(regData: regData, regDelegate: self)
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
    
    func location(_ latitude: String, longitude: String) {
        if !locationUpdated {
            payData!.latitude = latitude
            payData!.longitude = longitude
            locationUpdated = true
            DispatchQueue.main.async { [unowned self] in
                self.continuePay()
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
    
    func registration(_ id: String) {
        if let params = payData {
            params.registrationId = id
            Configuration.regId = id
            registrationCompleted = true
            DispatchQueue.main.async { [unowned self] in
                self.continuePay()
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
}
