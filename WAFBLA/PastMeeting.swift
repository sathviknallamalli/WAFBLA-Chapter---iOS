//
//  DrawerItemDetails.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/23/21.
//

import UIKit

class PastMeeting {

    var title: String
    var time: String
    var count: Int

    init?(title: String, time: String, count: Int) {
        
        // Initialize stored properties.
        self.title = title
        self.time = time
        self.count = count

    }

}
