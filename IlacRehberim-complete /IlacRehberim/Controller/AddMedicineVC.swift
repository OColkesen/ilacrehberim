//  AddMedicineVC.swift
//  IlacRehberim
//  Created by Oğuzhan Çölkesen on 14/03/2018.



import UIKit
import  UserNotifications
import UserNotificationsUI //framework to customize the notification

class AddMedicineVC: UIViewController, UITextFieldDelegate {
    
    //IBOUTLETS:
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var afterMealBtn: UIButton!
    @IBOutlet weak var beforeMealBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var hourLbl: UILabel!
    @IBOutlet weak var personalNoteLbl: UILabel!
    @IBOutlet weak var datePickerConstraint: NSLayoutConstraint!
    @IBOutlet weak var hourField: UITextField!
    @IBOutlet weak var personalNoteTxtView: UITextField!
    @IBOutlet weak var dosageField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var inStockField: UITextField!
    @IBOutlet weak var typePill: UIButton!
    @IBOutlet weak var typeLiquid: UIButton!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var noMealTimeBtn: UIButton!
    
    //VARIABLES:
    var pill = false
    var mealTime = "unimportant" // Can be three different states: "unimportant" , "before" , "after"
    var dateStr = ""

      let requestIdentifier = "SampleRequest" //identifier is to cancel the notification request
    
    override func viewDidLoad() {

        super.viewDidLoad()
        hourField.delegate = self
        personalNoteTxtView.delegate = self
        dosageField.delegate = self
        nameField.delegate = self
        inStockField.delegate = self
        
        datePickerConstraint.constant = 380
        afterMealBtn.setTitleColor(UIColor.blue, for: .normal)
        beforeMealBtn.setTitleColor(UIColor.blue, for: .normal)
        typePill.setTitleColor(UIColor.blue, for: .normal)
        typeLiquid.setTitleColor(UIColor.blue, for: .normal)
        noMealTimeBtn.setTitleColor(UIColor.green, for: .normal)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
         view.addGestureRecognizer(tap)
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func addMedicineTapped(_sender: Any) {
        
//        //Checking the inputs
        guard let name = nameField.text, name != "" else {
            self.errorLbl.text = "İlaç ismini belirtin lütfen !"
            return
        }
        guard let dosage = dosageField.text, dosage != "" else {
            self.errorLbl.text = "İlaç dosajı belirtin lütfen !"
            return
        }
        guard let inStock = inStockField.text, inStock != "" || pill != true else {
            self.errorLbl.text = "Ilacın stok durumunu belirtin lütfen !"
            return
        }
        guard let hour = hourField.text, hour != "" else {
            self.errorLbl.text = "İlacın kaç saate bir alınacağını belirtin lütfen !"
            return
        }
        guard let date = dateLbl.text, date != "" else {
            self.errorLbl.text = "İlacın ne zamana kadar alınacağını belirtin lütfen !"
            return
        }
        
        print("notification will be triggered ..Hold on tight")

        let content = UNMutableNotificationContent()
        content.title = "IIacRehberim"
       // content.subtitle = "Lets code,Talk is cheap"
        content.body = "Notification Trigger"
        content.sound = UNNotificationSound.default()
        
        
        // PRAGMA :- ------- Notification Hour Gap ---------
        
//        let hourfield = Int(hourField.text!)
//        // add notification for Mondays at 11:00 a.m.
//        var dateComponents = DateComponents()
//        //dateComponents.weekday = 3
//        dateComponents.hour = 11
//        dateComponents.minute = 42
//        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
        
      // 3600 second  = 1 hour
        
         let hourvalue = Int(hourField.text!)
         let second:Int = 3600
         let secondvalue:Int = hourvalue! * second
        
        print("second value is -------> ",secondvalue)
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(secondvalue), repeats: true)
       //  let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 60.0, repeats: true)
        
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                
                print(error?.localizedDescription)
            }
        }
        
        //Adding the medicine to the db
        postToFirebase()
    }
    
    func postToFirebase(){
        
//        if let note = personalNoteTxtView.tex
        let dosage = Double(dosageField.text!)
        let hour = Int(hourField.text!)
        
        var medicine: Dictionary<String, AnyObject> = [
            "name": self.nameField.text as AnyObject,
            "dosage": dosage as AnyObject,
            "inStock": "" as AnyObject,
            "hour": hour as AnyObject,
            "mealTime": mealTime as AnyObject,
            "personalNote": "" as AnyObject,
            "pill": pill as AnyObject,
            "toDate": dateStr as AnyObject
        ]

        if let personalNote = personalNoteTxtView.text {
            medicine["personalNote"] = personalNote as AnyObject
        }
        if let inStock = inStockField.text {
            medicine["inStock"] = inStock as AnyObject
        }
        print("TEST1: \(medicine)")
    DataService.ds.REF_USER_CURRENT.child("medicines").childByAutoId().setValue(medicine)
        performSegue(withIdentifier: "backToFeed", sender: self)
    }
    
    
    
    func ClearNotification() {
        
        let date2 = datePicker.date
        let today = Date()
        if today == date2
        {
            print("Date is Equal")
        }
        else if today > date2
        {
             print("today is greater")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:[requestIdentifier])
        }
        else if today < date2
        {
            print("today is less than")
        }
    }

    @IBAction func typePillTapped(_ sender: Any) {
        pill = true
        typePill.setTitleColor(UIColor.green, for: .normal)
        typeLiquid.setTitleColor(UIColor.blue, for: .normal)
        inStockField.isHidden = false
    }
    @IBAction func typeLiqTapped(_ sender: Any) {
        pill = false
        typeLiquid.setTitleColor(UIColor.green, for: .normal)
        typePill.setTitleColor(UIColor.blue, for: .normal)
        inStockField.isHidden = true
    }
    @IBAction func afterMealTapped(_ sender: Any) {
        mealTime = "after"
        afterMealBtn.setTitleColor(UIColor.green, for: .normal)
        beforeMealBtn.setTitleColor(UIColor.blue, for: .normal)
        noMealTimeBtn.setTitleColor(UIColor.blue, for: .normal)
    }
    @IBAction func beforeMealTapped(_ sender: Any) {
        mealTime = "before"
        beforeMealBtn.setTitleColor(UIColor.green, for: .normal)
        afterMealBtn.setTitleColor(UIColor.blue, for: .normal)
        noMealTimeBtn.setTitleColor(UIColor.blue, for: .normal)
    }

    @IBAction func noMealTimeTapped(_ sender: Any) {
        beforeMealBtn.setTitleColor(UIColor.blue, for: .normal)
        afterMealBtn.setTitleColor(UIColor.blue, for: .normal)
        noMealTimeBtn.setTitleColor(UIColor.green, for: .normal)
    }
    
    @IBAction func datePickerTapped(_ sender: Any) {

        if datePickerConstraint.constant == 380 {
            let date = datePicker.date
            dateLbl.text = date.toString(dateFormat: "dd-MM-yyyy")
            datePickerConstraint.constant = 0
            dateLbl.isHidden = true
            hourLbl.isHidden = true
            hourField.isHidden = true
            personalNoteLbl.isHidden = true
            personalNoteTxtView.isHidden = true
            dateBtn.setTitle("Devam", for: .normal)
//            dateBtn.setTitleColor(UIColor.red, for: .normal)
        } else {
            let date = datePicker.date
            dateStr = date.toString(dateFormat: "dd-MM-yyyy")
            dateLbl.text = dateStr
            datePickerConstraint.constant = 380
            dateLbl.isHidden = false
            hourLbl.isHidden = false
            hourField.isHidden = false
            personalNoteLbl.isHidden = false
            personalNoteTxtView.isHidden = false
            dateBtn.setTitle("Ne zamana kadar ilacı almaya devam edeceksin?", for: .normal)
            
        }
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hourField.resignFirstResponder()
        personalNoteTxtView.resignFirstResponder()
        dosageField.resignFirstResponder()
        nameField.resignFirstResponder()
        inStockField.resignFirstResponder()
        return true
    }

}
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}



extension AddMedicineVC:UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

          ClearNotification()
        print("Tapped in notification")
    }

    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        ClearNotification()
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier{
        
            completionHandler( [.alert,.sound,.badge])

        }
    }
}
