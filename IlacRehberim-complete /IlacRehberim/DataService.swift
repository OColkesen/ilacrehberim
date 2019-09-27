//
//  DataService.swift
//  IlacRehberim
//
//  Created by Oğuzhan Çölkesen on 11/03/2018.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()

class DataService {
    
    static let ds = DataService()
    private var _REF_BASE = DB_BASE
    private var _REF_MEDICINES = DB_BASE.child("Medicines")
    private var _REF_USERS = DB_BASE.child("users")

    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }

    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_MEDICINES: DatabaseReference {
        return _REF_MEDICINES
    }
    
    var REF_USER_CURRENT: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }

    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
    
        REF_USERS.child(uid).updateChildValues(userData)

    }
    
}


