//
//  UpdateSelectedViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/29/21.
//

import UIKit

class UpdateSelectedViewController: UIViewController{
    
    var item = UpdateDetails(title: "", label: "")

    @IBOutlet var selectedText: UILabel!
    @IBOutlet var selectedTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedText.text = item?.label
        selectedTitle.text = item?.title
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
