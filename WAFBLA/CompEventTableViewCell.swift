//
//  CompEventTableViewCell.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/23/21.
//

import UIKit

class CompEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventname: UILabel!
    
    @IBOutlet weak var eventtitle: UILabel!
    @IBOutlet weak var eventcategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
