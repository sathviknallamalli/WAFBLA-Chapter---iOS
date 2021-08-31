//
//  NotificationSelectedViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/29/21.
//

import UIKit

class NotificationSelectedViewController: UIViewController {
    var item = NotificationDetails(title: "", message: "", timestamp: "")

    @IBOutlet var theTitle: UILabel!
    @IBOutlet var text: UILabel!
    @IBOutlet var timestamp: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        theTitle.text = item?.title
        text.text = item?.message
        timestamp.text = item?.timestamp

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
