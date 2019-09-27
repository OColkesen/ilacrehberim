//  DetailVC.swift
//  IlacRehberim
//  Created by Oğuzhan Çölkesen on 14/03/2018.



import UIKit

class DetailVC: UIViewController {
    
    //IBOUTLETS:
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var inStcokLbl: UILabel!
    @IBOutlet weak var dosageLbl: UILabel!
    @IBOutlet weak var personalNoteLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var mealTimeLbl: UILabel!
    
    //VARIABLES:
    var myMedicine: Medicine!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dosage = String(myMedicine.dosage)

        if myMedicine.mealTime.uppercased() == "UNIMPORTANT" {
            mealTimeLbl.text = "Yemekten önce veya sonra alınabilir."
        } else if myMedicine.mealTime.uppercased() == "BEFORE" {
            mealTimeLbl.text = "Yemekten ÖNCE alınmalıdır."
        } else if myMedicine.mealTime.uppercased() == "AFTER" {
            mealTimeLbl.text = "Yemekten SONRA alınmalıdır."
        }

        nameLbl.text = myMedicine.name.uppercased()
        dosageLbl.text = dosage
        personalNoteLbl.text = myMedicine.personalNote.uppercased()
        dateLbl.text = myMedicine.toDate
        inStcokLbl.text = myMedicine.inStock

    }

    

}
