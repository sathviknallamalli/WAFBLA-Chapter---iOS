//
//  AllDoneViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/22/21.
//

import UIKit

class AllDoneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeButton(buttonName: startBut)

        // Do any additional setup after loading the view.
    }

    @IBOutlet var startBut: UIButton!
    @IBAction func getStarted(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "SWRevealViewController") as! SWRevealViewController

        self.present(controller, animated: true, completion: nil)
    }
    
    func customizeButton(buttonName: UIButton){
        let borderColor = (UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0))
        buttonName.layer.cornerRadius = 10
        buttonName.layer.borderWidth = 1.0
        buttonName.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        buttonName.layer.borderColor = UIColor.white.cgColor
        
    }
}
