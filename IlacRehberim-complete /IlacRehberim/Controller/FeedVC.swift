//  FeedVC.swift
//  IlacRehberim
//  Created by Oğuzhan Çölkesen on 14/03/2018.


import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //IBOUTLETS:
    @IBOutlet weak var tableView: UITableView!
    
    //VARIABLES:
    var medicines = [Medicine]()
    var theMedicine: Medicine?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        observe()

    }
    
    //TABLEVIEW FUNCTIONS:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicine = medicines[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell") as? MedicineCell {
            cell.configureCell(medicine: medicine)
            return cell
        } else {
            return MedicineCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicines.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        theMedicine = medicines[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    //OBSERVER:
    func observe() {
        DataService.ds.REF_USER_CURRENT.child("medicines").observe(.value, with: { (snapshot) in
            self.medicines = []
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let medicineDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let medicine = Medicine(key: key, data: medicineDict)
                        self.medicines.append(medicine)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destination as? DetailVC
            detailVC?.myMedicine = theMedicine
        }
    }

    //SignOut
    @IBAction func SignOutBtnTapped(_ sender: Any) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ARTH: ID removed from keychain: \(keychainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
        
    }

}
