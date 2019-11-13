//
//  RequestData.swift
//  AssistPayTest
//
//  Created by Sergey Kulikov on 02.07.15.
//  Copyright (c) 2015 Assist. All rights reserved.
//

import Foundation

open class RequestData: NSObject {
    func buildRequestString() -> String {
        return ""  // it must be overriden
    }
    
    func addHeaderProperties(_ request: NSMutableURLRequest) {
        // override if want add properties
    }
    
    func buldRequest(_ url: URL) -> URLRequest {
        let contents = buildRequestString()
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        addHeaderProperties(request)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = contents.data(using: .utf8)
        
        print("request contents \(contents)")
        
        return request as URLRequest
    }
    
    func urlencode(value: String) -> String {
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        
        if let escapedString = value.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
            return escapedString
        }
        return value
    }
}
