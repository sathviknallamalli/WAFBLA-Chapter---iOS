//
//  HeaderCell.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/24/21.
//

import UIKit
import Firebase

class HeaderCell: UITableViewCell {
    @IBOutlet weak var chapNameTitle: UILabel!
    weak var viewController: UIViewController?

    @IBOutlet weak var userAvatar: UIImageView!
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
      do {
        try firebaseAuth.signOut()
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        viewController?.present(controller, animated: true, completion: nil)
      } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
      }
    }
    @IBAction func share(_ sender: Any) {
    }
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var emailTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
