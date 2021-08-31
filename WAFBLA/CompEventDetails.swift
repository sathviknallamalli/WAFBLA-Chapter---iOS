//
//  EventDetails.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/23/21.
//

import Foundation

class CompEventDetails {
    
    var eventtitle: String
    var eventname: String
    var eventcategory: String


    init?(eventtitle: String, eventname: String, eventcategory: String) {
        
        // Initialize stored properties.
        self.eventtitle = eventtitle
        self.eventname = eventname
        self.eventcategory = eventcategory

        
    }

    
}
