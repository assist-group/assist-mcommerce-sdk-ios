//
//  SoapRequest.swift
//  AssistPayTest
//
//  Created by Sergey Kulikov on 16.07.15.
//  Copyright (c) 2015 Assist. All rights reserved.
//

import Foundation

class SoapRequest: RequestData {
    var data = [String:String]()
    let soapAction: String
    
    init(soapAction: String) {
        self.soapAction = soapAction
    }
    
    func buildRequestHeader() -> String {
        return String()  // must be overriden
    }
    
    func buildRequestTail() -> String {
        return String() // must be overriden
    }
    
    override func buildRequestString() -> String {
        var request = buildRequestHeader()
        
        for (key, value) in data {
            request += "<\(key)>\(value)</\(key)>\n"
        }
        
        request += buildRequestTail()
        
        return request
    }
    
    override func addHeaderProperties(_ request: NSMutableURLRequest) {
        request.setValue("text/xml", forHTTPHeaderField: "Content-Type")
        request.setValue("UTF-8", forHTTPHeaderField: "Content-Encoding")
        request.setValue(soapAction, forHTTPHeaderField: "SOAPAction")
    }
    
}

class SoapService: NSObject, NSURLConnectionDataDelegate, XMLParserDelegate, URLSessionDelegate {
    let faultcode = ".soapenv:Envelope.soapenv:Body.soapenv:Fault.faultcode"
    let faultstring = ".soapenv:Envelope.soapenv:Body.soapenv:Fault.faultstring"
    
    fileprivate var responseData = NSMutableData()
    fileprivate var currentElement = String()
    fileprivate var values = [String:String]()
    fileprivate var names = [String]()
    
    func getUrl() -> String {
        return String() // must be overriden
    }
    
    func clean() {
        responseData = NSMutableData()
        values = [String:String]()
    }
    
    func run(_ request: SoapRequest) {
        let requestData = request.buldRequest(URL(string: getUrl())!)
        
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: requestData) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            let parser = XMLParser(data: data as Data)
            parser.delegate = self
            parser.parse()
            parser.shouldResolveExternalEntities = true
        }
        
        task.resume()
    }
    
    func getElementName() -> String {
        return names.reduce("") {$0 + "." + $1}
    }
    
    func connection(_ connection: NSURLConnection, willSendRequestFor challenge: URLAuthenticationChallenge) {
        print("Connection: will send auth")
        
        let method = challenge.protectionSpace.authenticationMethod
        if method == NSURLAuthenticationMethodServerTrust {
            print("trusted host")
            if let trust = challenge.protectionSpace.serverTrust {
                challenge.sender?.use(URLCredential(trust: trust), for: challenge)
            }
        } else {
            print("not trusted host")
        }
        
        challenge.sender?.continueWithoutCredential(for: challenge)
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        print("Connection: response loaded \(response)")
        responseData.length = 0
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        print("Connection: data received \(data)")
        responseData.append(data)
    }
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        values[faultcode] = "500"
        values[faultstring] = error.localizedDescription
        
        finish(values)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        print("Connection: finish loading")
        
        let parser = XMLParser(data: responseData as Data)
        parser.delegate = self
        parser.parse()
        parser.shouldResolveExternalEntities = true
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("didBecomeInvalidWithError: \(String(describing: error))")
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("URLSessionDidFinishEventsForBackgroundURLSession: \(session)")
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        names.append(elementName)
        currentElement = getElementName()
        print("Parser: start element \(currentElement)")
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("Parser: found characters \(string)")
        values[currentElement] = string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("Parser: end element \(currentElement)")
        names.removeLast()
        currentElement = getElementName()
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Parser: end document")
        finish(values)
    }
    
    func finish(_ values: [String:String]) {
        // process response data
    }
}
