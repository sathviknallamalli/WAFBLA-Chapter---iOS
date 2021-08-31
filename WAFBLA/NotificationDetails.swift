//
//  NotificationDetails.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/24/21.
//

import Foundation

class NotificationDetails {
    
    var title: String
    var message: String
    var timestamp: String


    init?(title: String, message: String, timestamp: String) {
        
        // Initialize stored properties.
        self.title = title
        self.message = message
        self.timestamp = timestamp

        
    }

    
}
