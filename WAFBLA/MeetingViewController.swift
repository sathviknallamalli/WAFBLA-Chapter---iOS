//
//  MeetingViewController.swift
//  WAFBLA
//
//  Created by Sathvik Nallamalli on 3/24/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MeetingViewController: UIViewController {
    
    @IBOutlet weak var meetingID: UITextField!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var checkInButton: UIButton!
    
    @IBOutlet weak var errorText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorText.isHidden = true;
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let defaults = UserDefaults.standard
        let chapID = defaults.string(forKey:"chapID") ?? "noval"
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Chapters").child(chapID).child("Meetings")

        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists() && snapshot.hasChild("Attendees/" + Auth.auth().currentUser!.uid)){
                self.checkInButton.isEnabled = false
                
                let chapDict = snapshot.value as! [String: Any]
                let meetid = chapDict["ID"] as! String
                
                self.meetingID.text = meetid
                self.meetingID.isEnabled = false
                self.errorText.text = "You already checked in!"
                self.errorText.isHidden = false;
                           
                let alertController = UIAlertController(title: "Meeting", message: "You already checked in!", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        })

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func checkIn(_ sender: Any) {
        if(!checkInButton.isEnabled){
            let alertController = UIAlertController(title: "Meeting", message: "You already checked into this meeting! If you are trying to check into a new meeting, ask your adviser to end the current meeting.", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            var ref: DatabaseReference!
            let defaults = UserDefaults.standard
            let chapID = defaults.string(forKey:"chapID") ?? "noval"

            
            ref = Database.database().reference().child("Chapters").child(chapID).child("Meetings")
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if(snapshot.exists()){
                    
                    let chapDict = snapshot.value as! [String: Any]
                    let meetid = chapDict["ID"] as! String
                    let currentCount = chapDict["Attendance"] as! Int

                    if(self.meetingID.text == meetid){
                        
                        self.errorText.text = "Checked In!"
                        self.errorText.isHidden =  false
                        
                        let updatedCount = currentCount + 1
                        ref.child("Attendance").setValue(updatedCount)
                        ref.child("Attendees").child(Auth.auth().currentUser!.uid).setValue(true);

                        self.checkInButton.isEnabled = false;
                        self.meetingID.isEnabled = false

                        let alertController = UIAlertController(title: "Meeting", message: "Checked In!", preferredStyle: UIAlertController.Style.alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }else{
                        self.errorText.isHidden = false;
                    }
                }else{
                    self.errorText.isHidden = false;
                }
            })
        }
    }

}
