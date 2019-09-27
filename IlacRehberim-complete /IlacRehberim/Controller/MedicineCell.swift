//  MedicineCell.swift
//  IlacRehberim
//
//  Created by Oğuzhan Çölkesen on 14/03/2018.
//

import UIKit

class MedicineCell: UITableViewCell {
    
    //IBOUTLETS
    @IBOutlet weak var nameAndDosage: UILabel!
    @IBOutlet weak var personalNote: UILabel!
    @IBOutlet weak var nextReminder: UILabel!
    @IBOutlet weak var medicineImg: UIImageView!
    
    //VARIABLES
    var medicine: Medicine!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(medicine: Medicine) {
        self.medicine = medicine
        
        var typeOfDosage = ""
        if medicine.pill {
            typeOfDosage = "tablets"
        } else {
            typeOfDosage = "spoons/mL"
        }
        
        self.nameAndDosage.text = "\(medicine.name.capitalized) -  \(medicine.dosage) \(typeOfDosage)"
        self.personalNote.text = medicine.personalNote
        
        if medicine.pill {
            medicineImg.image = UIImage(named: "icons8-pill-filled-100")
        } else {
            medicineImg.image = UIImage(named: "icons8-dose-filled-100")
        }
    }

}
