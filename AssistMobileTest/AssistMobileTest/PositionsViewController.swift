//
//  PositionsViewController.swift
//  AssistMobileTest
//
//  Created by Timofey on 08/05/2020.
//  Copyright © 2020 Assist. All rights reserved.
//

import UIKit

class PositionsViewController: UIViewController {
    
    @IBOutlet weak var chequeItems: UITextView! {
        didSet {
            chequeItems.text = Settings.chequeItems ?? ""
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        Settings.chequeItems = chequeItems.text
        
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chequeItems!.layer.borderWidth = 1.0
        chequeItems!.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0).cgColor
        chequeItems!.layer.cornerRadius = 5.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
