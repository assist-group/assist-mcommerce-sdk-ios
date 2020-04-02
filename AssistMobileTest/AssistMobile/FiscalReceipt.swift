//
//  FiscalReceipt.swift
//  AssistMobile
//
//  Created by Timofey on 25/03/2020.
//  Copyright © 2020 Assist. All rights reserved.
//

import UIKit
import PassKit

@objc
public protocol AssistFiscalReceiptDelegate: class {
    func fiscalReceiptFinished(_ url: String)
}

@objc
open class FiscalReceipt: NSObject {
    
    fileprivate var pay: PayController
    
    @objc public init(delegate: AssistFiscalReceiptDelegate) {
        let bundle = Bundle(identifier: "ru.assist.AssistMobile")
        pay = PayController(nibName: "PayView", bundle: bundle)
        pay.fiscalReceiptDelegate = delegate
    }
    
    open func getFiscalReceipt(_ withData: PayData) {
        pay.payData = withData
        pay.getFiscalReceipt()
    }
}

