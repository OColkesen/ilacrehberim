
//
//  ButtonDesign.swift
//  IlacRehberim
//
//  Created by Oğuzhan Çölkesen on 11/03/2018.
//

import UIKit

class ButtonDesign: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5.0
        
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 0.8
        layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.6).cgColor
        layer.shadowRadius = 0.5
    }

}
