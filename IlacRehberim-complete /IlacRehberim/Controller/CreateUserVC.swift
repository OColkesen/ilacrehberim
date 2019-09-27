//  CreateUserVC.swift
//  IlacRehberim
//  Created by Oğuzhan Çölkesen on 14/03/2018.


import UIKit
import Firebase
import SwiftKeychainWrapper
import FirebaseAuth

class CreateUserVC: UIViewController, UITextFieldDelegate {

    //IBOUTLETS:
    @IBOutlet weak var emailField: FieldDesign!
    @IBOutlet weak var passwordField: FieldDesign!
    @IBOutlet weak var usernameField: FieldDesign!
    @IBOutlet weak var errorLbl: UILabel!
    //VARIABLES:

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func createUserBtnTapped(_ sender: Any) {

        guard let user = usernameField.text, user != "" else {
            errorLbl.text = "Kullanıcı adı eksik !"
            errorLbl.textColor = UIColor.red
            return
        }
        guard let password = passwordField.text, password != "" else {
            errorLbl.text = "Parola eksik !"
            errorLbl.textColor = UIColor.red
            return
        }
        guard let email = emailField.text, email != "" else {
            errorLbl.text = "Email eksik !"
            errorLbl.textColor = UIColor.red
            return
        }

        Auth.auth().fetchProviders(forEmail: emailField.text!) { (emails, error) in
            if emails == nil {
                print("ARTH: Email not in use.")
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        print("ARTH: Unable to authenticate with Firebase usinng email.")
                    } else {
                        print("ARTH: Successfully authenticated with Firebase with email.")

                        if let user = user {
                            let userData = ["provider": user.providerID]
                            self.completeSignin(id: user.uid, userData: userData)

                        }
                    }
                })
            } else {
                self.errorLbl.text = "Bu email başka bir kullanıcıda !"
            }
        }
    }

    //KEYCHAIN WRAPPER USER UID SAVE
    func completeSignin(id: String, userData: Dictionary<String, String>){
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        DataService.ds.REF_USER_CURRENT.child("username").setValue(usernameField.text)
        print("ARTH: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goIlacRehberim", sender: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        usernameField.resignFirstResponder()
        return true
    }
}

