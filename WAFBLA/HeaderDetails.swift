//
//  HeaderDetails.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/24/21.
//
class HeaderDetails {

    var chapName: String
    var fname: String
    var lname: String

    var email: String

    
    init?(chapName: String, fname: String, lname: String, email: String) {
        
        // Initialize stored properties.
        self.chapName = chapName + " FBLA"
        self.fname = fname
        self.lname = lname
        self.email = email


    }

}
