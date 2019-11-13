//
//  AssistPay.swift
//  AssistPayTest
//
//  Created by Sergey Kulikov on 21.07.15.
//  Copyright (c) 2015 Assist. All rights reserved.
//

import UIKit
import PassKit

public enum PaymentStatus: String
{
    case Unknown = "Unknown"
    case InProgress = "In Process"
    case Delayed = "Delayed"
    case Approved = "Approved"
    case PartialApproved = "PartialApproved"
    case PartialDelayed = "PartialDelayed"
    case Canceled = "Canceled"
    case PartialCanceled = "PartialCanceled"
    case Declined = "Declined"
    case Timeout = "Timeout"
    case Repeated = "Repeated"
}

@objc
public protocol AssistPayDelegate: class {
    func payFinished(_ bill: String, status: String, message: String?)
}

@objc
open class AssistPay: NSObject {
    
    fileprivate var pay: PayController
    fileprivate var applePay: AnyObject?
    
    @objc public init(delegate: AssistPayDelegate) {
        let bundle = Bundle(identifier: "ru.assist.AssistMobile")
        pay = PayController(nibName: "PayView", bundle: bundle)
        pay.payDelegate = delegate
        
        if #available(iOS 10.0, *) {
            applePay = ApplePayPayment(delegate: delegate)
        } else {
            // Fallback on earlier versions
        }
    }
    
    open func start(_ controller: UIViewController, withData: PayData) {
        pay.payData = withData
        controller.present(pay, animated: true, completion: nil)
    }
    
    open func getResult(_ withData: PayData) {
        pay.payData = withData
        pay.getResult()
    }
    
    @available(iOS 10.0, *)
    @objc open func startWithApplePay(_ controller: UIViewController, withData: PayData, applePayMerchantId: String) {
        (applePay! as! ApplePayPayment).pay(controller, withData: withData, withMerchantId: applePayMerchantId)
    }
    
}
