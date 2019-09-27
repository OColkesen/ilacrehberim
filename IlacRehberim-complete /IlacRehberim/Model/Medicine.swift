//
//  Medicine.swift
//  IlacRehberim
//
//  Created by Oğuzhan Çölkesen on 11/03/2018.
//

import Foundation
import Firebase


class Medicine {
    
    private var _key: String!
    private var _name: String!
    private var _dosage: Double!
    private var _personalNote: String!
    private var _hour: Int!
    private var _mealTime: String!  //can be "unimprtant" "before" "after" indicating before after
    private var _inStock: String!
    private var _medicineRef: DatabaseReference!
    private var _pill: Bool!  //to identify the type wether it is liquid based or solid
    private var _toDate: String!


    var key: String {
        return _key
    }
    var pill: Bool {
        return _pill
    }
    var mealTime: String {
        return _mealTime
    }
    var inStock: String {
        return _inStock
    }
    var name: String {
        return _name
    }
    var dosage: Double {
        return _dosage
    }
    var personalNote: String {
        return _personalNote
    }
    var hour: Int {
        return _hour
    }
    var toDate: String {
        return _toDate
    }
    
    
    init(key: String, data: Dictionary<String, AnyObject>) {
        self._key = key
        
        if let name = data["name"] as? String {
            self._name = name
        }
        if let dosage = data["dosage"] as? Double {
            self._dosage = dosage
        }
        if let personalNote = data["personalNote"] as? String {
            self._personalNote = personalNote
        }
        if let pill = data["pill"] as? Bool {
            self._pill = pill
        }
        if let mealTime = data["mealTime"] as? String {
            self._mealTime = mealTime
        }
        if let inStock = data["inStock"] as? String {
            self._inStock = inStock
        }
        if let hour = data["hour"] as? Int {
            self._hour = hour
        }
        if let toDate = data["toDate"] as? String {
            self._toDate = toDate
        }
        
        _medicineRef = DataService.ds.REF_MEDICINES.child(_key)
    }
    
  
    
}
