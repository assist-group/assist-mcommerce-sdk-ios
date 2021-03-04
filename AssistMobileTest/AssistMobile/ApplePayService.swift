//
//  ApplePayService.swift
//  AssistMobileTest
//
//  Created by Sergey Kulikov on 27.12.16.
//  Copyright © 2016 Assist. All rights reserved.
//
import Foundation
import PassKit

class ApplePayService: NSObject, URLSessionDelegate {
    
    fileprivate var data: PayData
    fileprivate var delegate: AssistPayDelegate
    fileprivate var completion: (PKPaymentAuthorizationStatus) -> Void
    
    init(requestData: PayData, delegate: AssistPayDelegate, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        data = requestData
        self.delegate = delegate
        self.completion = completion
    }
    
    func start() {
        run(data)
    }
    
    func getUrl(byOrder: Bool) -> String {
        let servicePath = byOrder ? AssistLinks.ApplePayByOrderService : AssistLinks.ApplePayService
        return AssistLinks.currentHost + servicePath
    }
    
    fileprivate func run(_ request: PayData) {
        let byOrder = !((request.link ?? "").isEmpty)
        let requestData = request.buldRequest(URL(string: getUrl(byOrder: byOrder))!)
        
        //print("\(requestData.httpMethod ?? "") \(requestData.url)")
        //let str = String(decoding: requestData.httpBody!, as: UTF8.self)
        //print("BODY \n \(str)")
        //print("HEADERS \n \(requestData.allHTTPHeaderFields)")
        
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: requestData) { sessionData, response, error in
            do {
                guard let sessionData = sessionData, error == nil else {
                    DispatchQueue.main.async {
                        self.completion(PKPaymentAuthorizationStatus.failure)
                        self.delegate.payFinished("", status: "Unknown", message: error as! String?)
                    }
                    return
                }
            
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.delegate.payFinished("", status: "Unknown", message: "Bad status code: \(httpStatus.statusCode)")
                        self.completion(PKPaymentAuthorizationStatus.failure)
                    }
                }
                
                //let da = String(data: sessionData, encoding: .utf8)
                //print("full response is \(da)")
            
                var status = PKPaymentAuthorizationStatus.failure
                var paymentStatus = "Unknown"
                var message = "Can not get result"
                var billnumber = ""
            
                if let json = try JSONSerialization.jsonObject(with: sessionData) as? [String:Any] {
                    //print("response is \(json)")
                    if let orders = json["order"] as? [Any] {
                        if let order = orders[0] as? [String:Any] {
                            if let operations = order["operations"] as? [Any] {
                                if let operation = operations[0] as? [String:Any] {
                                    message = operation["message"] as? String ?? ""
                                }
                            }
                            paymentStatus = order["orderstate"] as? String ?? "Unknown"
                            billnumber = order["billnumber"] as? String ?? ""
                        }
                    } else {
                        if let firstcode = json["firstcode"] as? Int {
                            let secondcode = json["secondcode"] as? Int
                            message = "firstcode: \(firstcode), secondcode: \(String(describing: secondcode))"
                        }
                    }
                }
            
                if paymentStatus == "Approved" {
                    status = PKPaymentAuthorizationStatus.success
                }
            
                DispatchQueue.main.async {
                    self.completion(status)
                    self.delegate.payFinished(billnumber, status: paymentStatus, message: message)
                }
            } catch let error {
                print (error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
