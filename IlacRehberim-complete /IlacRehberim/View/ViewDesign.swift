//
//  ViewDesign.swift
//  IlacRehberim
//
//  Created by Oğuzhan Çölkesen on 12/03/2018.
//

import UIKit

class ViewDesign: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.6).cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 5.0
        
    }
}
