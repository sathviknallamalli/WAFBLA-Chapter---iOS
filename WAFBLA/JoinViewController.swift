//
//  JoinViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/21/21.
//

import UIKit
import FirebaseDatabase

class JoinViewController: UIViewController {
    
    
    @IBOutlet weak var join: UIButton!
    @IBOutlet weak var chapID: UITextField!
    
    @IBOutlet weak var errorStatement: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeButton(buttonName: join)

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
    
    @IBAction func joinChapter(sender: UIButton) {
        var ref: DatabaseReference!

        ref = Database.database().reference()
        let chapterID = chapID.text
                
        if(chapterID != ""){
            ref.child("Chapters").child(chapterID!).child("Setup").observeSingleEvent(of: .value, with: { (snapshot) in

                if (snapshot.exists()){
                    
                    let chapDict = snapshot.value as! [String: Any]
                    let chapterName = chapDict["ChapterName"] as! String
                    let chapterState = chapDict["State"] as! String
                    let chapterZip = chapDict["Zip"] as! String
                    
                    var message = "Chapter name: " + chapterName + "\nID: " + chapterID!
                    message += "\nState: " + chapterState + "\nZip: " + chapterZip

                    let alertController = UIAlertController(
                        title: "Confirm Chapter", message: message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: { // Also action dismisses AlertController when pressed.
                                action in

                        
                        self.performSegue(withIdentifier: "moveToChooseRole", sender: self)
                        
                       

                    })
                    alertController.addAction(action)// add action to alert


                       self.present(alertController, animated: true, completion: nil)
                    }else{
                        self.errorStatement.text = "This chapter ID does not exist."
                    }


                })
        }else{
            self.errorStatement.text = "Enter chapter ID"
        }

       
        
        
       }
    
    func customizeButton(buttonName: UIButton){
        let borderColor = (UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0))
        buttonName.layer.cornerRadius = 10
        buttonName.layer.borderWidth = 1.0
        buttonName.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        buttonName.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "moveToChooseRole") {
            let vc = segue.destination as! UserRoleViewController
            vc.chapterID = chapID.text!
        }
    }

}
