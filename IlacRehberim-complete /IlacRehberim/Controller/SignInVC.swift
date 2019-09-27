//  SignInVC.swift
//  IlacRehberim
//  Created by Oğuzhan Çölkesen on 11/03/2018.


import UIKit
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

class SignInVC: UIViewController, UITextFieldDelegate {
    
    //IBOUTLETS:
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    //KEYCHAIN WRAPPER
    override func viewDidAppear(_ animated: Bool) {
        if KeychainWrapper.standard.string(forKey: KEY_UID) != nil {
            print("ARTH: Keychain Uid found: \(KEY_UID)")
            performSegue(withIdentifier: "goToIlacRehberim", sender: nil)
        }
    }

    //FIREBASE EMAIL AUTH
    @IBAction func singInTapped(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text {
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("ARTH: User authenticated with firebase.")
                    if let user = user {
                        let userData = ["email": user.email]
                        self.completeSignIn(id: user.uid, userData: userData as! Dictionary<String, String>)
                    }
                } else {
                    self.errorLbl.text = "Hesap bulunamadı !"
                }
            })
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("ARTH: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToIlacRehberim", sender: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        textField.resignFirstResponder()
        return true
    }

}
