//
//  FieldDesign.swift
//  IlacRehberim
//
//  Created by Oğuzhan Çölkesen on 11/03/2018.
//

import UIKit

class FieldDesign: UITextField, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

