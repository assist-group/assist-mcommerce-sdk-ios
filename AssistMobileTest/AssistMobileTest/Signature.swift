//
//  Sinature.swift
//  AssistPayTest
//
//  Created by Sergey Kulikov on 04.08.15.
//  Copyright (c) 2015 Assist. All rights reserved.
//

import Foundation
import Security

class Signature {
    
    static func digest(_ data: String) -> Data
    {
        let str = data.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(data.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let digestData = Data(bytes: UnsafePointer<UInt8>(result), count: digestLen)
        result.deinitialize(count: 1)
        return digestData
    }
    
    static func sign(_ key: SecKey, data: Data) -> Data?
    {
        let size = SecKeyGetBlockSize(key)
        let sig = NSMutableData(length: size)!
        let sigbytes = UnsafeMutablePointer<UInt8>(OpaquePointer(sig.mutableBytes))
        var sigLen = sig.length
        let status = SecKeyRawSign(key, SecPadding.PKCS1, (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), data.count, sigbytes, &sigLen
        )
        if status == errSecSuccess {
            sig.length = sigLen
            return sig as Data
        }
        print("SecKeyRawSign error: \(status)")
        return nil
    }
    
    static func base64Encode(_ data: Data) -> String
    {
        return data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    static func calc(_ data: String, key: SecKey) -> String?
    {
        print("data is \(data), key is \(key)")
        let digestData = digest(data)
        print("digestData is \(digestData)")
        if let signData = sign(key, data: digestData) {
            print("signData is \(signData)")
            return base64Encode(signData)
        } else {
            print("sign returns nil")
            return nil
        }
    }
    
    static func generateKeys() -> (publicKey: SecKey?, privateKey: SecKey?)
    {
        var publicKeyPtr: SecKey?
        var privateKeyPtr: SecKey?
        
        // private key parameters
        let privateKeyParams = [
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: "ru.assist.mobile.keypair"
        ] as [String : Any]
        
        // private key parameters
        let publicKeyParams: [String: AnyObject] = [
            kSecAttrIsPermanent as String: true as AnyObject,
            kSecAttrApplicationTag as String: "ru.assist.mobile.keypair" as AnyObject
        ]
        
        let parameters = [
            kSecAttrType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 1024,
            kSecPublicKeyAttrs as String: publicKeyParams,
            kSecPrivateKeyAttrs as String: privateKeyParams,
        ] as [String : Any]
        
        let status = SecKeyGeneratePair(parameters as CFDictionary, &publicKeyPtr, &privateKeyPtr)
        if status == errSecSuccess {
            return (publicKeyPtr, privateKeyPtr)
        }
        
        return (nil, nil)
    }
    
    static func secKeyToNSData(_ key: SecKey) -> Data?
    {
        let tempTag = "ru.assist.mobile.sdk.temp"
        var parameters : [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: tempTag,
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecValueRef: key
        ]
        
        parameters[kSecReturnData] = true
        var keyPtr: CFTypeRef?
        let result = SecItemAdd(parameters as CFDictionary, &keyPtr)
        
        switch result {
        case noErr:
            let data = keyPtr as! Data
            
            SecItemDelete(parameters as CFDictionary)
            return data
        case errSecDuplicateItem:
            print("Duplicate item!")
            SecItemDelete(parameters as CFDictionary)
        case errSecItemNotFound:
            print("Not found!")
        default:
            print("Error: \(result)")
        }
        return nil
    }
    
    static func nsDataToPrivateSecKey(_ data: Data) -> SecKey?
    {
        let tempTag = "ru.assist.mobile.sdk.temp"
        var parameters : [String: Any] = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrApplicationTag): tempTag,
            String(kSecValueData): data,
            String(kSecAttrKeyClass): kSecAttrKeyClassPrivate,
            String(kSecAttrKeyType): kSecAttrKeyTypeRSA,
        ]
        
        parameters[String(kSecReturnPersistentRef)] = kCFBooleanTrue
        var keyRefPtr: CFTypeRef?
        let result = SecItemAdd(parameters as CFDictionary, &keyRefPtr)
        
        switch result {
        case noErr:
            parameters.removeValue(forKey: String(kSecValueData))
            parameters.removeValue(forKey: String(kSecReturnPersistentRef))
            parameters[String(kSecReturnRef)] = kCFBooleanTrue
            
            var keyPtr: CFTypeRef?
            
            let copyResult = SecItemCopyMatching(parameters as CFDictionary, &keyPtr)
            
            SecItemDelete(parameters as CFDictionary)
            if copyResult != noErr {
                print("SecItemCopyMatching error: \(copyResult)")
                return nil
            }
            if let key = keyPtr {
                return (key as! SecKey)
            } else {
                print("empty or bad key")
            }
            
        case errSecDuplicateItem:
            print("Duplicate item!")
            SecItemDelete(parameters as CFDictionary)
        case errSecItemNotFound:
            print("Not found!")
        default:
            print("Error: \(result)")
        }
        return nil
    }
}
