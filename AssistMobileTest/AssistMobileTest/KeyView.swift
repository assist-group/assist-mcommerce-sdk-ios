//
//  KeyView.swift
//  AssistPayTest
//
//  Created by Sergey Kulikov on 06.08.15.
//  Copyright (c) 2015 Assist. All rights reserved.
//

import UIKit

class KeyView: UIView {
    
    var key: Data? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if let data = key {
            let string = Signature.base64Encode(data)
            
            print("string is \(string)")
            // set the text color to dark gray
            let fieldColor: UIColor = UIColor.darkGray
            
            // set the font to Helvetica Neue 18
            let fieldFont = UIFont(name: "Helvetica Neue", size: 8)
            
            // set the line spacing to 6
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = 6.0
            
            // set the Obliqueness to 0.1
            let skew = 0.1
            
            let attributes = [
                NSAttributedString.Key.foregroundColor.rawValue: fieldColor,
                NSAttributedString.Key.paragraphStyle: paraStyle,
                NSAttributedString.Key.obliqueness: skew,
                NSAttributedString.Key.font: fieldFont!
                ] as! [NSAttributedString.Key : Any]
            
            string.draw(in: rect, withAttributes: attributes)
        }
    }
    
}
