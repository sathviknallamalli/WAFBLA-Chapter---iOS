//
//  NotificationTableViewCell.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/24/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var timestampText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var messageText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
