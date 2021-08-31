//
//  StatsViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/28/21.
//

import UIKit
import FirebaseDatabase

class StatsViewController: UIViewController {

    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var role2: UILabel!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var role1: UILabel!
    @IBOutlet var grad4: UILabel!
    @IBOutlet var grad3: UILabel!
    @IBOutlet var grad2: UILabel!
    @IBOutlet var grad1: UILabel!
    @IBOutlet var total: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let defaults = UserDefaults.standard
        let chapID = defaults.string(forKey:"chapID") ?? "noval"
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Chapters").child(chapID)

        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.hasChild("Users")){
                let dict = snapshot.value as! [String: Any]
                let userdict = dict["Users"] as! [String: Any]
                let adviserdict = dict["Advisers"] as! [String: Any]
                
                var g1: Int = 0
                var g2: Int = 0
                var g3: Int = 0
                var g4: Int = 0
                
                self.total.text =  "\(userdict.count + adviserdict.count - 1) users"
                self.role1.text = "\(userdict.count) users"
                self.role2.text = "\(adviserdict.count - 1) users"

                for rest in userdict {
                    
                    let dict = rest.value as! [String: Any]
                    let grad = dict["graduationyear"] as! String
                    if(grad == "2021"){
                        g1+=1
                    } else if(grad == "2022"){
                        g2+=1
                    } else if(grad == "2023"){
                        g3+=1
                    } else if(grad == "2024"){
                        g4+=1
                    }

                }
                self.grad1.text = "\(g1) members"
                self.grad2.text = "\(g2) members"
                self.grad3.text = "\(g3) members"
                self.grad4.text = "\(g4) members"

            }
        })
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
